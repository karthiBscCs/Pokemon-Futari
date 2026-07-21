#===============================================================================
#  Luka's Scripting Utilities
#
#  Core extensions for the `Array` data types
#===============================================================================
# Core extensions for the Array data type adding swap, lookup and presence
# helpers.
class ::Array
  # Swaps specific indexes
  # @param index1 [Integer] first index to swap
  # @param index2 [Integer] second index to swap
  # @return [Object] value assigned to the second index
  def swap_at(index1, index2)
    val1 = self[index1].clone
    val2 = self[index2].clone
    self[index1] = val2
    self[index2] = val1
  end

  # Pushes value to last index
  # @param val [Object] value to move to the end
  # @return [Array] self with the value at the last index
  def to_last(val)
    delete(val) if include?(val)
    push(val)
  end

  # Checks if the given index is the last index of the array.
  # @param index [Integer] index to check
  # @return [Boolean] whether the index is the last one
  def last?(index)
    (length - 1).eql?(index)
  end

  # Checks if any string element is contained within the given value.
  # @param val [String] string to match elements against
  # @return [Boolean] whether the value includes any string element
  def string_include?(val)
    return false unless val.is_a?(String)

    each do |a|
      return true if a.is_a?(String) && val.include?(a)
    end

    false
  end

  # Fetches the element at the given index.
  # @param index [Integer] index to fetch
  # @return [Object] element at the index
  def value(index)
    self[index]
  end

  # Checks if the array has no elements.
  # @return [Boolean] whether the array is empty
  def blank?
    empty?
  end

  # Checks if the array has any elements.
  # @return [Boolean] whether the array is not empty
  def present?
    !blank?
  end
end
