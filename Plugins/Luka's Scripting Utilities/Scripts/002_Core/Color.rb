#===============================================================================
#  Luka's Scripting Utilities
#
#  Core extensions for the `Color` class
#===============================================================================
# Core extensions for the `Color` class, adding animation support, common
# color presets and conversion helpers.
class ::Color
  # Allows color components to be animated easily
  include ::LUTS::Concerns::Animatable

  # Fully transparent black color.
  # @return [Color] blank color
  def self.blank
    Color.new(0, 0, 0, 0)
  end

  # Dark gray color preset.
  # @return [Color] dark gray color
  def self.dark_gray
    Color.new(64, 64, 64)
  end

  # Returns a copy of the color darkened by the given amount.
  # @param amt [Numeric] darkening fraction (0.0-1.0)
  # @return [Color] darkened color
  def darken(amt = 0.2)
    r = red - red * amt
    g = green - green * amt
    b = blue - blue * amt

    Color.new(r, g, b)
  end

  # Checks whether all color components are zero.
  # @return [Boolean] whether the color is fully transparent black
  def blank?
    red.zero? && green.zero? && blue.zero? && alpha.zero?
  end

  # Checks whether any color component is non-zero.
  # @return [Boolean] whether the color is not blank
  def present?
    !blank?
  end

  # Converts the color to a normalized RGB vector.
  # @return [Array<Float>] red, green and blue components (0.0-1.0)
  def to_vec3
    [red / 255.0, green / 255.0, blue / 255.0]
  end

  # Converts the color to a normalized RGBA vector.
  # @return [Array<Float>] red, green, blue and alpha components (0.0-1.0)
  def to_vec4
    [red / 255.0, green / 255.0, blue / 255.0, alpha / 255.0]
  end
end
