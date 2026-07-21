#===============================================================================
#  Luka's Scripting Utilities
#
#  Core extensions for the `Viewport` class
#===============================================================================
class ::Viewport
  # Extended Viewport class with animation, tagging, and utility methods.
  # Allows viewport components to be animated easily
  include LUTS::Concerns::Animatable
  # Allows viewport components to take blocks during instanciation
  include LUTS::Concerns::BlockConstructor
  # Allows viewport components to use float values for smooth calculations
  include LUTS::Concerns::Floatable
  # Adds DSL for shader usage
  include LUTS::Concerns::Shaderable

  # Finds all viewports with the specified tag.
  # @param tag [Symbol] tag to search for
  # @return [Array<Viewport>] all viewports with this tag
  def self.get_by_tag(tag)
    [].tap do |array|
      ObjectSpace.each_object(Viewport) do |viewport|
        array << viewport if viewport.tag?(tag)
      end
    end
  end

  # Returns the list of tags assigned to this viewport.
  # @return [Array<Symbol>] tags assigned to this viewport
  def tags
    @tags ||= []
  end

  # Adds a tag to this viewport.
  # @param value [Symbol] tag to add
  # @return [Symbol] the added tag
  def tag=(value)
    tags << value
  end

  # Checks if this viewport has the specified tag.
  # @param tag [Symbol] tag to check for
  # @return [Boolean] true if this viewport has the tag
  def tag?(tag)
    tags.include?(tag)
  end

  # Returns all sprites belonging to this viewport.
  # @return [Array<Sprite>] all sprites belonging to this viewport
  def sprites
    [].tap do |array|
      ObjectSpace.each_object(Sprite) do |sprite|
        next if sprite.disposed?

        array << sprite if sprite.viewport.eql?(self)
      end
    end
  end

  # Flattens all sprites in this viewport into a single bitmap.
  # @return [Bitmap] rendered bitmap with all visible sprites
  def flatten
    bmp = Bitmap.new(width, height)
    sprites.sort { |a, b| [a.z, a.__id__] <=> [b.z, b.__id__] }.each do |sprite|
      next unless sprite.bitmap
      next unless sprite.visible

      rect = Rect.new(sprite.apparent_x, sprite.apparent_y, sprite.apparent_width, sprite.apparent_height)
      bmp.stretch_blt(rect, sprite.bitmap, sprite.src_rect, sprite.opacity)
    end

    bmp
  end

  # Removes any applied color from this viewport.
  # @return [Color] the blank color applied
  def reset_color
    self.color = Color.blank
  end

  # Returns the width of this viewport's rect.
  # @return [Integer] viewport width in pixels
  def width
    rect.width
  end

  # Sets the width of this viewport's rect.
  # @param val [Integer] new width in pixels
  # @return [Integer] the new width
  def width=(val)
    rect.width = val
  end

  # Returns the height of this viewport's rect.
  # @return [Integer] viewport height in pixels
  def height
    rect.height
  end

  # Sets the height of this viewport's rect.
  # @param val [Integer] new height in pixels
  # @return [Integer] the new height
  def height=(val)
    rect.height = val
  end

  # Returns the x-coordinate of this viewport's rect.
  # @return [Integer] x-coordinate in pixels
  def x
    rect.x
  end

  # Sets the x-coordinate of this viewport's rect.
  # @param val [Integer] new x-coordinate in pixels
  # @return [Integer] the new x-coordinate
  def x=(val)
    rect.x = val
  end

  # Returns the y-coordinate of this viewport's rect.
  # @return [Integer] y-coordinate in pixels
  def y
    rect.y
  end

  # Sets the y-coordinate of this viewport's rect.
  # @param val [Integer] new y-coordinate in pixels
  # @return [Integer] the new y-coordinate
  def y=(val)
    rect.y = val
  end

  # Returns the alpha (transparency) value of this viewport's color.
  # @return [Integer] color alpha value (0-255)
  def alpha
    color.alpha
  end

  # Sets the alpha (transparency) value of this viewport's color.
  # @param val [Integer] new alpha value (0-255)
  # @return [Integer] the new alpha value
  def alpha=(val)
    color.alpha = val
  end
end
