#===============================================================================
#  Luka's Scripting Utilities
#
#  Base sprite class for new sprite engine
#===============================================================================
# Namespace for the custom sprite engine classes.
module Sprites
  # Base sprite class extending the engine `Sprite` with bitmap manipulation,
  # positioning, coloring and animation helper attributes.
  class Base < ::Sprite
    # @return [Bitmap] bitmap memorized through `memorize_bitmap`
    attr_reader   :stored_bitmap
    # @return [Numeric] additional attributes used in various scripts
    attr_accessor :direction, :speed, :toggle, :end_x, :end_y, :param, :skew_d
    # @return [Numeric] additional attributes used in various scripts
    attr_accessor :ex, :ey, :zx, :zy, :dx, :dy
    # @return [Boolean] additional attributes used in various scripts
    attr_accessor :finished

    # Creates a new sprite with default attribute values and yields itself
    # to an optional configuration block.
    # @param viewport [Viewport] viewport to render the sprite in
    # @param block [Proc] optional configuration block called with the sprite
    # @yieldparam sprite [Sprites::Base] the newly created sprite
    # @return [Sprites::Base] the new sprite instance
    def initialize(viewport, &block)
      super(viewport)

      default!
      block.call(self) if block_given?
    end

    # Sets default additional attribute values
    # @return [void]
    def default!
      @speed     = 1
      @toggle    = 1
      @end_x     = 0
      @end_y     = 0
      @ex        = 0
      @ey        = 0
      @zx        = 1
      @zy        = 1
      @param     = 1
      @direction = 1
      @finished  = false
    end

    #---------------------------------------------------------------------------
    # Dimensional properties of sprite
    # Gets width of the sprite source rect
    # @return [Integer] sprite width in pixels
    def width
      src_rect.width
    end

    # Sets width of the sprite source rect
    # @param val [Integer] new sprite width in pixels
    # @return [Integer] assigned width
    def width=(val)
      src_rect.width = val
    end

    # Gets height of the sprite source rect
    # @return [Integer] sprite height in pixels
    def height
      src_rect.height
    end

    # Sets height of the sprite source rect
    # @param val [Integer] new sprite height in pixels
    # @return [Integer] assigned height
    def height=(val)
      src_rect.height = val
    end

    # Gets uniform sprite zoom factor
    # @return [Numeric] horizontal zoom factor
    def zoom
      zoom_x
    end

    # Sets uniform zoom on both axes
    # @param val [Numeric] new zoom factor
    # @return [Numeric] assigned zoom factor
    def zoom=(val)
      self.zoom_x = val
      self.zoom_y = val
    end

    #---------------------------------------------------------------------------
    # Bitmap properties of sprites
    # Sets sprite bitmap from path or bitmap object
    # @param bmp [String, Bitmap] bitmap path or bitmap object
    # @return [void]
    def set_bitmap(bmp)
      self.bitmap = SpriteHash.bitmap(bmp)
    end

    # Sets color rect as sprite bitmap
    # @param width [Integer] rect width in pixels
    # @param height [Integer] rect height in pixels
    # @param color [Color] fill color
    # @return [void]
    def create_rect(width, height, color)
      self.bitmap = Bitmap.new(width, height).fill_rect(0, 0, width, height, color)
    end

    # Sets sprite bitmap to fill entire screen with color
    # @param color [Color] fill color
    # @return [void]
    def full_rect(color)
      self.bitmap ||= blank_screen
      bitmap.fill_rect(0, 0, bitmap.width, bitmap.height, color)
    end

    # Sets blank bitmap the size of viewport
    # @return [Bitmap] newly assigned blank bitmap
    def blank_screen
      self.bitmap = Bitmap.new(viewport.width, viewport.height)
    end

    # Takes screenshot and set as sprite bitmap
    # @return [void]
    def snap_screen
      self.bitmap = Bitmap.new(viewport.width, viewport.height)
      bitmap.blt(0, 0, Graphics.snap_to_bitmap, Rect.new(viewport.x, viewport.y, viewport.width, viewport.height))
    end

    # Draws bitmap stretched across entire screen
    # @param path [String] path to the bitmap file
    # @return [void]
    def stretch_screen(path)
      bmp = LUTS::Sprites.bitmap(path)

      self.bitmap = Bitmap.new(viewport.width, viewport.height)
      bitmap.stretch_blt(bitmap.rect, bmp, bmp.rect)
      bmp.dispose
    end

    # Memorizes current bitmap
    # @param bmp [Bitmap] bitmap to memorize instead of the current one
    # @return [Bitmap] cloned stored bitmap
    def memorize_bitmap(bmp = nil)
      @stored_bitmap = (bmp || bitmap)&.clone
    end

    # Restores memorized bitmap
    # @return [void]
    def restore_bitmap
      self.bitmap = @stored_bitmap.clone
    end

    # Applies bitmap from URL source
    # @param url [String] URL of the bitmap to download
    # @return [void]
    def online_bitmap(url)
      self.bitmap = LUTS::Sprites.online_bitmap(url)
    end

    # Masks bitmap with another bitmap
    # @param mask [Bitmap] bitmap used as the mask
    # @param ox [Integer] mask X offset
    # @param oy [Integer] mask Y offset
    # @return [void]
    def mask(mask = nil, ox: 0, oy: 0)
      return unless bitmap

      self.bitmap = bitmap.mask(mask, ox, oy)
    end

    # Creates bitmap with applied system font
    # @param width [Integer] bitmap width in pixels
    # @param height [Integer] bitmap height in pixels
    # @return [void]
    def text_sprite(width = viewport.width, height = viewport.height)
      self.bitmap = Bitmap.new(width, height)
      pbSetSystemFont(self.bitmap)
    end

    #-------------------------------------------------------------------------
    # Color components
    # Gets alpha value of the sprite color
    # @return [Integer] color alpha value
    def alpha
      color.alpha
    end

    # Sets alpha value of the sprite color
    # @param val [Integer] new color alpha value
    # @return [Integer] assigned alpha value
    def alpha=(val)
      color.alpha = val
    end

    # Swap color pallette
    # @param map [Bitmap] color map used for the swap
    # @return [void]
    def swap_colors(map)
      bitmap&.swap_colors(map)
    end

    # Gets average color of bitmap
    # @param freq [Integer] color sampling frequency
    # @return [Color] averaged bitmap color
    def avg_color(freq: 2)
      return Color.new(0, 0, 0, 0) unless bitmap

      width  = bitmap.width / freq
      height = bitmap.height / freq
      red    = 0
      green  = 0
      blue   = 0

      n = width * height
      width.times do |x|
        height.times do |y|
          color = bitmap.get_pixel(x * freq, y * freq)
          next unless color.alpha.positive?

          red   += color.red
          green += color.green
          blue  += color.blue
        end
      end

      Color.new(red / n, green / n, blue / n)
    end

    # Applies blur to sprite
    # @return [void]
    def blur
      bitmap.blur
    end

    # Draws outline on sprite
    # @param color [Color] outline color
    # @return [void]
    def outline(color)
      return unless bitmap

      # creates temp outline bmp
      out = Bitmap.new(bitmap.width, bitmap.height)
      5.times do |i| # corners
        x = (i / 2).zero? ? -r : r
        y = i.even? ? -r : r
        out.blt(x, y, bitmap, bitmap.rect)
      end

      5.times do |i| # edges
        x = i < 2 ? 0 : (i.even? ? -r : r)
        y = i >= 2 ? 0 : (i.even? ? -r : r)
        out.blt(x, y, bitmap, bitmap.rect)
      end
      # analyzes the pixel contents of both bitmaps
      # iterates through each X coordinate
      bitmap.width.times do |x|
        # iterates through each Y coordinate
        bitmap.height.times do |y|
          c1 = bitmap.get_pixel(x, y) # target bitmap
          c2 = out.get_pixel(x, y) # outline fill
          # compares the pixel values of the original bitmap and outline bitmap
          bitmap.set_pixel(x, y, color) if c1.alpha <= 0 && c2.alpha.positive?
        end
      end
      # disposes temp outline bitmap
      out.dispose
    end

    # Applies color to solid pixels of sprite
    # @param color [Color] color to apply
    # @param amount [Integer] color intensity (0-255)
    # @return [void]
    def colorize(color, amount: 255)
      return unless bitmap

      alpha = amount / 255.0
      # iterates through each X coordinate
      bitmap.width.times do |x|
        # iterates through each Y coordinate
        bitmap.height.times do |y|
          pixel = bitmap.get_pixel(x, y)
          next unless pixel.alpha.positive?

          r = alpha * color.red + (1 - alpha) * pixel.red
          g = alpha * color.green + (1 - alpha) * pixel.green
          b = alpha * color.blue + (1 - alpha) * pixel.blue

          bitmap.set_pixel(x, y, Color.new(r, g, b))
        end
      end
    end

    # Draws glow on sprite
    # @param color [Color] glow color
    # @param keep [Boolean] whether or not the original bitmap is drawn over
    # @return [void]
    def glow(color, keep: true)
      return unless bitmap

      src = bitmap.clone.blur
      bitmap.clear
      bitmap.stretch_blt(Rect.new(-0.005 * src.width, -0.015 * src.height, src.width * 1.01, 1.02 * src.height), src, Rect.new(0, 0, src.width, src.height))
      bitmap.blt(0, 0, temp_bmp, Rect.new(0, 0, temp_bmp.width, temp_bmp.height)) if keep

      self.color = color
      src.dispose
    end

    #-------------------------------------------------------------------------
    # Positional components
    # Gets center point coordinates of the sprite
    # @return [Array<Integer>] sprite center
    def center
      [width / 2, height / 2]
    end

    # Center sprite on itself
    # @param snap [Boolean] center sprite in relation to viewport
    # @return [void]
    def center!(snap: false)
      anchor(:middle)
      # aligns with the center of the sprite's viewport
      return unless snap && viewport

      self.x = viewport.rect.width / 2
      self.y = viewport.rect.height / 2
    end

    # Gets bottom center point coordinates of the sprite
    # @return [Array<Integer>] bottom center coordinates
    def bottom
      [width / 2, height]
    end

    # Sets sprite anchor to bottom center
    # @return [void]
    def bottom!
      anchor(:bottom_middle)
    end

    # Sets sprite anchor
    # @param type [Symbol] anchor position (`:middle`, `:bottom_left`, `:top_right`, ...)
    # @return [void]
    def anchor(type)
      case type
      when :bottom_left
        self.ox = 0
        self.oy = height
      when :bottom_middle
        self.ox = width / 2
        self.oy = height
      when :bottom_right
        self.ox = width
        self.oy = height
      when :middle_left
        self.ox = 0
        self.oy = height / 2
      when :middle
        self.ox = width / 2
        self.oy = height / 2
      when :middle_right
        self.ox = width
        self.oy = height / 2
      when :top_left
        self.ox = 0
        self.oy = 0
      when :top_middle
        self.ox = width / 2
        self.oy = 0
      when :top_right
        self.ox = width
        self.oy = 0
      end
    end
  end
end
