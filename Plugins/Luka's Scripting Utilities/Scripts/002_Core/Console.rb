#===============================================================================
#  Luka's Scripting Utilities
#
#  Core extensions for the `Console` module
#===============================================================================
# Core extensions for the `Console` module, adding markup-aware echo helpers.
module ::Console
  # Console class methods.
  class << self
    # Function to echo to console without line break
    # @param msg [String] message to echo
    # @param options [Hash] markup styling options
    # @return [void]
    def echo_str(msg, options = {})
      echo markup_style(markup(msg), **options)
    end

    # Extend paragraph echo
    # @param msg [String] message to echo
    # @param options [Hash] markup styling options
    # @return [void]
    def echo_p(msg, options = {})
      echoln markup_style(markup(msg), **options)
    end
  end
end
