#===============================================================================
#  Luka's Scripting Utilities
#
#  Core extensions for the `File` class
#===============================================================================
class ::File
  class << self
    # Safely checks if a .rxdata file exists and is readable.
    # @param file [String] file path to check
    # @return [Boolean] true if file exists and can be loaded, false otherwise
    def safe_data?(file)
      load_data(file) ? true : false
    rescue StandardError
      false
    end
  end
end
