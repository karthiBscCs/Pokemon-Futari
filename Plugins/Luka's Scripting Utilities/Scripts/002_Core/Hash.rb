#===============================================================================
#  Luka's Scripting Utilities
#
#  Core extensions for the `Hash` class
#===============================================================================
# Core extensions for the `Hash` class with value access, merging and
# presence helpers.
class ::Hash
  # Returns the value associated with the given key.
  # @param key [Object] key to look up
  # @return [Object] value associated with key
  def value(key)
    self[key]
  end

  # Merges many hashes into self
  # @param hashes [Array<Hash>] hashes to merge into self
  # @return [Hash] self with all hashes merged in
  def merge_many(*hashes)
    tap do |output|
      hashes.each do |hash|
        hash.each do |key, value|
          output[key] = value
        end
      end
    end
  end

  # Checks whether the hash has no keys.
  # @return [Boolean] true if hash is empty
  def blank?
    keys.empty?
  end

  # Checks whether the hash has any keys.
  # @return [Boolean] true if hash is not empty
  def present?
    !blank?
  end
end
