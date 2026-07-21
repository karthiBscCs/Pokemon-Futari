#===============================================================================
#  Luka's Scripting Utilities
#
#  Sheet sprite class for new sprite engine
#===============================================================================
# Namespace for the custom sprite engine classes.
module Sprites
  # Sprite that animates through frames of a spritesheet bitmap.
  class Sheet < Base
    # @return [Integer] current animation frame counter
    attr_reader   :cur_frame
    # @return [Numeric] number of update ticks per frame
    attr_accessor :speed

    # Sets default attribute values
    # @return [void]
    def default!
      super
      @frames    = 1
      @speed     = 1
      @cur_frame = 0
      @vertical  = false
    end

    # Sets sprite bitmap
    # @param file [String] bitmap filename to load
    # @param frames [Integer] number of frames in the sheet
    # @param vertical [Boolean] whether frames are stacked vertically
    # @param speed [Numeric] number of update ticks per frame
    # @return [void]
    def set_bitmap(file, frames: 1, vertical: false, speed: @speed)
      @speed    = speed
      @frames   = frames
      @vertical = vertical

      self.bitmap = SpriteHash.bitmap(file)

      if @vertical
        src_rect.height /= @frames
      else
        src_rect.width /= @frames
      end
    end

    # Updates sprite animation
    # @return [void]
    def update
      return unless bitmap

      if @cur_frame.lerp >= @speed
        if @vertical
          src_rect.y += src_rect.height
          src_rect.y = 0 if src_rect.y >= bitmap.height
        else
          src_rect.x += src_rect.width
          src_rect.x = 0 if src_rect.x >= bitmap.width
        end
        @cur_frame = 0
      end
      @cur_frame += 1
    end
  end
end
