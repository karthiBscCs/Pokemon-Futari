#===============================================================================
#  Luka's Scripting Utilities
#
#  Core extensions for the `Symbol` class
#===============================================================================
# Core extensions for the `Symbol` class with presence helpers.
class ::Symbol
  # Checks whether the symbol is blank; symbols never are.
  # @return [Boolean] always false
  def blank?
    false
  end

  # Checks whether the symbol is present; symbols always are.
  # @return [Boolean] always true
  def present?
    true
  end
end
