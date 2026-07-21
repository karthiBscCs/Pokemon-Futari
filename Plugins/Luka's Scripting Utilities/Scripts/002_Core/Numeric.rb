#===============================================================================
#  Luka's Scripting Utilities
#
#  Core extensions for the `Numeric` class
#===============================================================================
# Adds utility methods to the Numeric class for interpolation and time conversions.
class ::Numeric
  # Interpolates the number based on the current frame rate for frame-rate independence.
  # @param inverse [Boolean] whether to apply inverse interpolation
  # @return [Numeric] the interpolated value
  def lerp(inverse: false)
    # time per frame, for a target of 60 FPS
    target = 60.0 / Graphics.average_frame_rate
    target = 1.0 / target if inverse

    self * target
  end

  # Checks whether the numeric value is zero (blank).
  # @return [Boolean] whether the value is zero
  def blank?
    zero?
  end

  # Checks whether the numeric value is non-zero (present).
  # @return [Boolean] whether the value is non-zero
  def present?
    !blank?
  end

  # Converts the number to the equivalent number of frames in a minute.
  # @return [Integer] number of frames in the given minutes
  def minute
    minutes
  end

  # Converts the number to the equivalent number of frames in the given minutes.
  # @return [Integer] number of frames in the given minutes
  def minutes
    to_i * 60
  end

  # Converts the number to the equivalent number of frames in an hour.
  # @return [Integer] number of frames in the given hours
  def hour
    hours
  end

  # Converts the number to the equivalent number of frames in the given hours.
  # @return [Integer] number of frames in the given hours
  def hours
    to_i * 60 * 60
  end

  # Converts the number to the equivalent number of frames in a day.
  # @return [Integer] number of frames in the given days
  def day
    days
  end

  # Converts the number to the equivalent number of frames in the given days.
  # @return [Integer] number of frames in the given days
  def days
    to_i * 24 * 60 * 60
  end
end
