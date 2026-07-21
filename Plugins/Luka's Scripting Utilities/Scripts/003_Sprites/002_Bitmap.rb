#===============================================================================
#  Luka's Scripting Utilities
#
#  Base bitmap class for new sprite engine
#===============================================================================
module Sprites
  # Extended Bitmap class with additional drawing and manipulation utilities.
  class Bitmap < ::Bitmap
    # @return [String] file path used to load this bitmap
    attr_accessor :path

    # Initialize a new bitmap, optionally loading from a file path.
    # @param args [Array<String, Integer>] standard bitmap creation arguments or file path string
    # @param block [Proc] optional block called with the new bitmap instance
    # @return [void]
    def initialize(*args, &block)
      @path = args.first if args.first.is_a?(String)

      super(*args)
      block.call(self) if block_given?
    end

    # Draws a circle on this bitmap.
    # @param color [Color] circle color
    # @param radius [Integer] circle radius in pixels
    # @param hollow [Boolean] if true draws outline only, otherwise fills the circle
    # @return [void]
    def draw_circle(color, radius:, hollow: false)
      # basic circle formula
      # (x - center_x)**2 + (y - center_y)**2 = r**2
      width.times do |x|
        f = (radius**2 - (x - width / 2)**2)
        next if f.negative?

        y1 = -Math.sqrt(f).to_i + height / 2
        y2 = Math.sqrt(f).to_i + height / 2

        if hollow
          set_pixel(x, y1, color)
          set_pixel(x, y2, color)
        else
          fill_rect(x, y1, 1, y2 - y1, color)
        end
      end
    end

    # Renders text onto this bitmap.
    # @param text [String] text to render
    # @param x [Integer] x-coordinate for text position
    # @param y [Integer] y-coordinate for text position
    # @param align [Symbol] text alignment (:left, :center, :right)
    # @param base [Color] base text color
    # @param shadow [Color] shadow color
    # @param outline [Boolean] if true adds an outline to the text
    # @return [void]
    def render_text(text, x:, y:, align: :left, base: Color.white, shadow: Color.dark_gray, outline: false)
      data = [text, x, y, align, base, shadow]
      data.push(:outline) if outline
      pbDrawTextPositions(self, [data])
    end

    # Renders wrapped text within a bounded box on this bitmap.
    # @param text [String] text to render
    # @param x [Integer] x-coordinate for text box
    # @param y [Integer] y-coordinate for text box
    # @param width [Integer] width of text box in pixels
    # @param lines [Integer] maximum number of lines to display
    # @param line_height [Integer] height of each line in pixels
    # @param base [Color] base text color
    # @param shadow [Color] shadow color
    # @return [void]
    def render_text_ex(text, x:, y:, width:, lines:, line_height: 32, base: Color.white, shadow: Color.dark_gray)
      drawTextEx(self, x, y, width, lines, text, base, shadow, line_height)
    end

    # Sets font parameters for subsequent text rendering.
    # @param name [String] font name
    # @param size [Integer] font size
    # @param bold [Boolean] if true applies bold styling
    # @return [void]
    def set_font(name:, size:, bold: false)
      font.name = name
      font.size = size
      font.bold = bold
    end

    # Applies a mask to this bitmap, using alpha channel from the mask image.
    # @param mask [Bitmap, Sprite, String, nil] the mask to apply; can be a Bitmap, Sprite with bitmap, or file path string
    # @param offset_x [Integer] x-offset for mask alignment
    # @param offset_y [Integer] y-offset for mask alignment
    # @return [Bitmap, Boolean] masked bitmap or false if mask is invalid
    def mask!(mask = nil, offset_x: 0, offset_y: 0)
      bitmap = clone
      case mask
      when Bitmap
        mbmp = mask
      when Sprite
        mbmp = mask.bitmap
      when String
        mbmp = LUTS::Sprites.bitmap(mask)
      else
        return false
      end

      cbmp = Bitmap.new(mbmp.width, mbmp.height)
      mask = mbmp.clone
      ox = (bitmap.width - mbmp.width) / 2
      oy = (bitmap.height - mbmp.height) / 2
      width = mbmp.width + ox
      height = mbmp.height + oy

      (oy...height).each do |y|
        (ox...width).each do |x|
          pixel = mask.get_pixel(x - ox, y - oy)
          color = bitmap.get_pixel(x - offset_x, y - offset_y)
          alpha = pixel.alpha
          alpha = color.alpha if color.alpha < pixel.alpha

          cbmp.set_pixel(x - ox, y - oy, Color.new(color.red, color.green, color.blue, alpha))
        end
      end

      mask.dispose
      cbmp
    end

    # Swaps colors in this bitmap based on a color map defined in another bitmap.
    # @param bmp [Bitmap] bitmap where first row defines source colors and second row defines target colors
    # @return [void]
    def swap_colors(bmp)
      map = {}.tap do |map_hash|
        bmp.width.times do |x|
          start = bmp.get_pixel(x, 0)
          final = bmp.get_pixel(x, 1)

          map_hash[[start.red, start.green, start.blue]] = [final.red, final.green, final.blue]
        end
      end
      # failsafe
      return unless map.is_a?(Hash)

      # iterate over sprite's pixels
      width.times do |x|
        height.times do |y|
          pixel = get_pixel(x, y)
          next if pixel.alpha.zero?

          final = nil
          map.each_key do |key|
            # check for key mapping
            target = Color.new(*key)
            final  = Color.new(*map[key]) if tolerance?(pixel, target)
          end
          # swap current pixel color with target
          set_pixel(x, y, final) if final.is_a?(Color)
        end
      end
    end

    # Applies a tone directly to this bitmap's pixel data.
    # @param tone [Tone] tone to apply
    # @return [void]
    def apply_tone(tone)
      # Get raw pixel data
      pixels = raw_data.unpack('C*')

      # Process 4 pixels at a time (16 bytes) for better performance
      (0...pixels.length).step(16) do |i|
        # Bulk process multiple pixels
        end_idx = [i + 15, pixels.length - 1].min

        (i..end_idx).step(4) do |pixel_base|
          break if pixel_base + 2 >= pixels.length

          r, g, b = tone.lookup_table.transform(
            pixels[pixel_base],
            pixels[pixel_base + 1],
            pixels[pixel_base + 2]
          )

          pixels[pixel_base]     = r
          pixels[pixel_base + 1] = g
          pixels[pixel_base + 2] = b
        end
      end

      # Write modified data back to bitmap
      self.raw_data = pixels.pack('C*')
    end

    # Checks if a pixel color matches a target color within a tolerance threshold.
    # @param pixel [Color] pixel color to check
    # @param target [Color] target color to compare against
    # @return [Boolean] true if pixel matches color within tolerance
    def tolerance?(pixel, target)
      tol = 0.05

      return false unless pixel.red.between?(target.red - target.red * tol, target.red + target.red * tol)
      return false unless pixel.green.between?(target.green - target.green * tol, target.green + target.green * tol)
      return false unless pixel.blue.between?(target.blue - target.blue * tol, target.blue + target.blue * tol)

      true
    end

    # Checks if this bitmap has finished any pending animation.
    # @return [Boolean] always returns true; bitmaps have no inherent animation
    def finished?
      true
    end
  end
end
