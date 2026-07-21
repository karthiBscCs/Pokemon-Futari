#===============================================================================
#  Luka's Scripting Utilities
#
#  SpriteHash - wrapper for handling RMXP sprite hashes
#===============================================================================
# Wrapper around a hash of sprites, providing batch creation, configuration,
# updating and disposal of RMXP sprite collections.
class SpriteHash
  # @return [SpriteHash::SpriteCollection] collection exposing sprites as accessors
  attr_reader :hash
  # @return [Viewport] viewport shared by all sprites in the hash
  attr_reader :viewport

  # Class method to get bitmap from path or other bitmapable object
  # @param path [String, Bitmap, Rect, Object] path or bitmapable object
  # @return [Bitmap] resolved bitmap
  def self.bitmap(path)
    return path if path.is_a?(Bitmap)
    return Sprites::Bitmap.new(path.width, path.height) if path.is_a?(Rect)
    return path.bitmap if path.respond_to?(:bitmap) && path.bitmap

    bitmap = RPG::Cache.fromCache(path) || Sprites::Bitmap.new(path)
    RPG::Cache.setKey(path, bitmap)
    bitmap
  rescue Errno::ENOENT
    LUTS::ErrorMessages::ImageNotFound.new(path).raise
    ::Bitmap.new(2, 2)
  end

  # Downloads a bitmap and returns it
  # @param url [String] URL to download the bitmap from
  # @return [Bitmap, nil] downloaded bitmap, or nil if the file is unsafe
  def self.online_bitmap(url)
    file_name = url.split('/').last
    pbDownloadToFile(url, file_name)
    return nil unless File.safe_data?(file_name)

    bitmap = bitmap(file_name)
    File.delete(file_name)

    bitmap
  end

  # Sets up an empty sprite hash bound to a viewport.
  # @param viewport [Viewport] viewport shared by all sprites in the hash
  # @return [SpriteHash] new sprite hash instance
  def initialize(viewport = nil)
    @viewport = viewport
    @sprites  = {}
    @hash     = SpriteCollection.new(@sprites)
  end

  # Adds new sprite to sprite hash
  # @param key [Symbol] key to store the sprite under
  # @param options [Hash] sprite type, class, bitmap and attribute options
  # @param block [Proc] block called with the created sprite
  # @return [Sprites::Base] created sprite
  def add(key, options = {}, &block)
    if options.key?(:object)
      @sprites[key] = options[:object]
      return @hash.add(key)
    end

    @sprites[key] = sprite_instance(options[:type], options[:class])

    # apply bitmap (allow key value arguments)
    if options[:bitmap]
      if options[:bitmap].is_a?(Hash)
        @sprites[key].set_bitmap(self.class.bitmap(options[:bitmap][:file]), **options[:bitmap].except(:file))
      else
        @sprites[key].set_bitmap(self.class.bitmap(options[:bitmap]))
      end
    end

    options.except(:type, :bitmap, :class).each do |option, value|
      next set_value(key, "#{option}=".to_sym, value) if @sprites[key].respond_to?("#{option}=".to_sym)
      next unless @sprites[key].respond_to?(option)

      set_value(key, option, value)
    end

    @hash.add(key)
    block.call(@sprites[key]) if block_given?
    @sprites[key]
  end

  # Adds sprite already instanciated elsewhere
  # @param key [Symbol] key to store the sprite under
  # @param object [Object] pre-instanciated sprite object
  # @param block [Proc] block called with the added sprite
  # @return [Object] added sprite
  def add_raw(key, object, &block)
    @sprites[key] = object
    block.call(@sprites[key]) if block_given?
    @sprites[key]
  end

  # Fetches a sprite by its key.
  # @param key [Symbol] key of the sprite to fetch
  # @return [Object] sprite from sprite hash based on key
  def [](key)
    @sprites[key]
  end

  # Lists all sprite keys in the hash.
  # @return [Array<Symbol>] all available sprite keys
  def keys
    @sprites.keys
  end

  # Checks whether a sprite is registered under the given key.
  # @param key [Symbol] key to look up
  # @return [Boolean] whether the key exists
  def key?(key)
    @sprites.keys.include?(key)
  end

  # Iterates through sprite hash with code block
  # @param block [Proc] block called with each key and sprite pair
  # @return [void]
  def each(&block)
    return unless block_given?

    @sprites.each do |key, sprite|
      block.call(key, sprite)
    end
  end

  # Iterates through each sprite in hash
  # @param block [Proc] block called with each sprite
  # @return [void]
  def each_sprite(&block)
    return unless block_given?

    @sprites.each_value do |sprite|
      block.call(sprite)
    end
  end

  # Iterates through each key in hash
  # @param block [Proc] block called with each key
  # @return [void]
  def each_key(&block)
    return unless block_given?

    @sprites.each_key do |key|
      block.call(key)
    end
  end

  # Selects only evaluated blocks
  # @param block [Proc] predicate called with each key and sprite pair
  # @return [Hash] sprites matching the predicate
  def select(&block)
    return @sprites unless block_given?

    @sprites.select do |key, sprite|
      block.call(key, sprite)
    end
  end

  # Rejects only evaluated blocks
  # @param block [Proc] predicate called with each key and sprite pair
  # @return [Hash] sprites not matching the predicate
  def reject(&block)
    return @sprites unless block_given?

    @sprites.reject do |key, sprite|
      block.call(key, sprite)
    end
  end

  # Update all sprites in sprite hash
  # @return [void]
  def update
    @sprites.each_value(&:update)
  end

  # Sets viewport across all sprites
  # @param val [Viewport] viewport to assign
  # @return [Viewport] assigned viewport
  def viewport=(val)
    @viewport = val
    @sprites.each_value { |sprite| sprite.viewport = @viewport }
  end

  # Disposes all available sprites
  # @param options [Hash] `:only` and `:except` key filters
  # @return [void]
  def dispose(options = {})
    @sprites.keys.reject { |key| Array(options[:except]).include?(key) }.each do |key|
      next if options[:only] && !Array(options[:only]).include?(key)
      next if @sprites[key]&.disposed?

      @sprites[key].dispose
      @sprites.delete(key)
    end
  end

  # Checks whether all sprites have been disposed.
  # @return [Boolean] whether the hash is empty
  def disposed?
    @sprites.keys.empty?
  end

  # Set value for all sprites in hash
  # @param options [Hash] attribute names mapped to values
  # @return [void]
  def set(options = {})
    @sprites.each_key do |key|
      options.except(:type, :class).each do |option, value|
        next set_value(key, "#{option}=".to_sym, value) if @sprites[key].respond_to?("#{option}=".to_sym)
        next unless @sprites[key].respond_to?(option)

        set_value(key, option, value)
      end
    end
  end

  private

  # Creates sprite instance from params
  # @param type [Symbol] sprite type resolved under the `Sprites` namespace
  # @param klass [Class, String] explicit sprite class override
  # @return [Sprites::Base] created sprite instance
  def sprite_instance(type = nil, klass = nil)
    return (klass.is_a?(String) ? klass.constantize : klass).new(@viewport) if klass
    return Sprites::Base.new(@viewport) unless type

    "Sprites::#{type.to_s.camelize}".constantize.new(@viewport)
  rescue NameError
    LUTS::ErrorMessages::SpriteError.new(type.to_s.camelize).raise
    Sprites::Base.new(@viewport)
  end

  # Sets sprite instance variable based on available methods
  # @param key [Symbol] key of the target sprite
  # @param option [Symbol] setter or method name to invoke
  # @param value [Object] value to assign or pass to the method
  # @return [Object] result of the invoked method
  def set_value(key, option, value)
    return @sprites[key].send(option, value) if option.to_s.chars.last.eql?('=')

    if @sprites[key].method(option).arity.positive?
      if value.is_a?(Array)
        @sprites[key].send(option, *value)
      elsif value.is_a?(Hash)
        @sprites[key].send(option, **value)
      else
        @sprites[key].send(option, value)
      end
    else
      @sprites[key].send(option)
    end
  end

  # Sprite hash class to implicitly define sprite accessors
  class SpriteCollection
    # Wraps the underlying sprites hash.
    # @param sprites [Hash] sprites hash to expose
    # @return [SpriteHash::SpriteCollection] new collection instance
    def initialize(sprites = nil)
      @sprites = sprites
    end

    # Adds key to sprite collection
    # @param key [Symbol] key to define an accessor for
    # @return [void]
    def add(key)
      return if key.to_s.numeric?

      instance_variable_set("@#{key}", @sprites[key])
      self.class.attr_accessor(key.to_sym)
    end

    # Fetches the first sprite in the collection.
    # @return [Object] first sprite
    def first
      @sprites[@sprites.keys.first]
    end

    # Fetches the last sprite in the collection.
    # @return [Object] last sprite
    def last
      @sprites[@sprites.keys.last]
    end

    # Fetches a sprite by its key.
    # @param key [Symbol] key of the sprite to fetch
    # @return [Object] sprite stored under the key
    def [](key)
      @sprites[key]
    end
  end
end
