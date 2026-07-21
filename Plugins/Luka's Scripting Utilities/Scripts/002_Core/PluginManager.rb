#===============================================================================
#  Luka's Scripting Utilities
#
#  Core extensions for the `PluginManager` module
#===============================================================================
# Extensions to PluginManager for directory lookup and metadata handling.
module ::PluginManager
  class << self
    # Finds the directory of a plugin by matching its name in meta.txt files.
    # @param plugin [String] the plugin name to search for
    # @return [String, nil] the directory path of the plugin, or nil if not found
    def self.find_dir(plugin)
      # go through the plugins folder
      Dir.get('Plugins').each do |dir|
        next unless Dir.safe?(dir) || safeExists?("#{dir}/meta.txt")

        # read meta
        meta = readMeta(dir, 'meta.txt')
        return dir if meta[:name] == plugin
      end

      # return nil if no plugin dir found
      nil
    end
  end
end
