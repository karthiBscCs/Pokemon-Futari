#===============================================================================
#  Luka's Scripting Utilities
#
#  Core extensions for the `Rect` class
#===============================================================================
# Core extensions for the built-in `Rect` class, adding animation and
# float-based positioning support.
class ::Rect
  # Allows rect components to be animated easily
  include ::LUTS::Concerns::Animatable
  # Allows sprite components to use float values for smooth calculations
  include LUTS::Concerns::Floatable

  # No-op update hook for compatibility with animatable components.
  # @return [void]
  def update; end
end
