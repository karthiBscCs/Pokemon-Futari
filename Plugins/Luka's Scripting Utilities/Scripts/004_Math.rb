#===============================================================================
#  Luka's Scripting Utilities
#
#  Mathematical utilities
#===============================================================================
# Namespace for Luka's Scripting Utilities.
module LUTS
  # Mathematical helpers for geometric calculations.
  module Math
    class << self
      # Calculates XY coordinates for all points of a polygon
      # @param n [Integer] number of polygon points
      # @param radius [Integer] distance of each point from the center
      # @param width [Integer] x coordinate of the polygon center
      # @param height [Integer] y coordinate of the polygon center
      # @param angle [Integer] starting angle in degrees
      # @return [Array<Array<Float>>] XY coordinate pairs for each point
      def polygon_points(n, radius:, width:, height:, angle: 0)
        step = 360 / n

        [].tap do |points|
          n.times do
            x = width + radius * Math.cos(angle * (Math::PI / 180))
            y = height - radius * Math.sin(angle * (Math::PI / 180))
            points << [x, y]
            angle += step
          end
        end
      end

      # Calculates random XY coodrinate on the circumference of a circle
      # @param radius [Integer] circle radius
      # @param x [Integer, nil] x coordinate to use, random when nil
      # @return [Array<Integer>] XY coordinate pair on the circumference
      def rand_circle_coord(radius, x:)
        x ||= rand(radius * 2)

        y1 = -Math.sqrt(radius**2 - (x - radius)**2)
        y2 = Math.sqrt(radius**2 - (x - radius)**2)

        [x, (rand(2).zero? ? y1.to_i : y2.to_i) + r]
      end
    end
  end
end
