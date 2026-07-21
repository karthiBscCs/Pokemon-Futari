#===============================================================================
#  Luka's Scripting Utilities
#
#  * Various object extensions
#===============================================================================
# Namespace for Luka's scripting utilities.
module LUTS
  # Namespace for mixin modules shared across objects.
  module Concerns
    #  Animation automation module.
    #  Registers attribute values that will be used when calculating
    #  the animation progress
    module Animatable
      #  Registers target attribute values to animate towards.
      #  @param options [Hash{Symbol => Numeric}] properties and their target values
      #  @return [void]
      def animate(options)
        return if animating?

        @anim_target = {}.tap do |hash|
          next hash[options] = nil if options.is_a?(Symbol)

          options.each do |property, value|
            next unless respond_to?(property)

            hash[property] = [send(property), send(property), value]
          end
        end
        Graphics.target_object_cache << self
      end

      # Currently registered animation targets.
      # @return [Hash{Symbol => Numeric}] properties mapped to animation values
      def anim_target
        @anim_target ||= {}
      end

      # Advances each registered property towards its target value.
      # @param duration [Integer] duration in frames (with a target FPS of 60)
      # @return [void]
      def play_target_animation(duration)
        # animates each property specified for object
        anim_target.each do |property, value|
          next send(property) if respond_to?(property) && value.nil?
          next unless respond_to?("#{property}=")

          k = value.first < value.last ? 1 : -1
          next unless k * (value.last - send(property)) > 0

          diff = value.last - value.first
          if duration.positive?
            anim_target[property][1] += (diff / duration.to_f).lerp
          else
            anim_target[property][1] = value.last
          end
          # increment values based on delta interpolation
          send("#{property}=", anim_target[property][1])
        end
      end

      # Clear currently animating values
      # @return [void]
      def clear_anim_target
        anim_target.clear
      end

      # Checks whether any animation targets are registered.
      # @return [Boolean] whether the object is animating
      def animating?
        !anim_target.empty?
      end
    end
  end
end
