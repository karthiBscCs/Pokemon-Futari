#===============================================================================
#  Luka's Scripting Utilities
#
#  Core extensions for the `Graphics` module
#===============================================================================
module ::Graphics
  class << self
    # @return [Array<Object>] cache of objects waiting to be animated
    def target_object_cache
      @target_object_cache ||= []
    end

    # Animates a code block over a specified frame duration with automatic cache cleanup.
    # @param duration [Integer] animation duration in frames
    # @param block [Proc] block to execute each frame
    # @return [void]
    def animate(duration, &block)
      # calculates initial timings (converts frames to microseconds)
      start_timer   = System.uptime
      time_duration = (duration / 60.0)

      # starts graphics update loop
      loop do
        # runs animation block
        block&.call
        target_object_cache.each do |object|
          next unless object.respond_to?(:play_target_animation)

          object.play_target_animation(duration)
          # object.update
        end
        update

        # break if animation has run its course
        break if (System.uptime - start_timer) >= time_duration
      end

      # clear all animation targets
      target_object_cache.each do |object|
        next unless object.respond_to?(:clear_anim_target)

        object.clear_anim_target
      end

      # clear all animation objects
      target_object_cache.clear
    end
  end
end
#===============================================================================
# Clear target cache (soft reset fix)
Graphics.target_object_cache.clear
