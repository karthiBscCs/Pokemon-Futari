#===============================================================================
#  Luka's Scripting Utilities
#
#  Core extensions for the `Nil` class
#===============================================================================
# Extends NilClass with utility methods for nil checking.
class ::NilClass
  # Returns true since nil is always blank.
  # @return [Boolean] true
  def blank?
    true
  end

  # Returns false since nil is never present.
  # @return [Boolean] false
  def present?
    false
  end
end
