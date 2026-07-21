#===============================================================================
#  Luka's Scripting Utilities
#
#  Utility for defining custom error messages
#===============================================================================
# Container module for Luka's scripting utilities.
module LUTS
  # Collection of custom error message classes logged through the LUTS logger.
  module ErrorMessages
    # Base class structure
    class BaseError
      # Abstract constructor. Must be implemented by subclasses.
      # @return [void]
      def initialize
        raise NotImplementedError
      end

      # Logs the error message at the configured level.
      # @return [void]
      def raise
        ::LUTS::Logger.send(level, message)
      end

      private

      # Abstract log level. Must be implemented by subclasses.
      # @return [Symbol] log level
      def level
        raise NotImplementedError
      end

      # Abstract error message. Must be implemented by subclasses.
      # @return [String] error message
      def message
        raise NotImplementedError
      end
    end

    # Unable to find bitmap error
    class ImageNotFound < BaseError
      # Class constructor
      # @param path [String] path of the missing image
      # @return [LUTS::ErrorMessages::ImageNotFound] new error instance
      def initialize(path)
        @path = path
      end

      private

      # Log level of the error.
      # @return [Symbol] log level
      def level
        :error
      end

      # Composed error message.
      # @return [String] error message
      def message
        "Image located at \"#{@path}\" was not found!"
      end
    end

    # Unable to create sprite instance error
    class SpriteError < BaseError
      # Class constructor
      # @param name [String] name of the sprite class
      # @return [LUTS::ErrorMessages::SpriteError] new error instance
      def initialize(name)
        @name = name
      end

      private

      # Log level of the error.
      # @return [Symbol] log level
      def level
        :warn
      end

      # Composed error message.
      # @return [String] error message
      def message
        "Unable to instanciate `Sprites::#{@name}`! No such class!"
      end
    end

    # Unable to use component
    class ComponentError < BaseError
      # Class constructor
      # @param name [String] name of the component
      # @return [LUTS::ErrorMessages::ComponentError] new error instance
      def initialize(name)
        @name = name
      end

      private

      # Log level of the error.
      # @return [Symbol] log level
      def level
        :warn
      end

      # Composed error message.
      # @return [String] error message
      def message
        "Unable to load `#{@name}` component! No such class!"
      end
    end

    # Unable to find function
    class MissingFunctionError < BaseError
      # Class constructor
      # @param klass [Class] class missing the function
      # @param function [Symbol] name of the missing function
      # @return [LUTS::ErrorMessages::MissingFunctionError] new error instance
      def initialize(klass, function)
        @klass    = klass
        @function = function
      end

      private

      # Log level of the error.
      # @return [Symbol] log level
      def level
        :warn
      end

      # Composed error message.
      # @return [String] error message
      def message
        "Undefined function `#{@function}' for class `#{@klass}'!"
      end
    end

    # Wrong number of vertices
    class VertexError < BaseError
      # Class constructor
      # @param vertices [Integer] minimum number of required vertices
      # @return [LUTS::ErrorMessages::VertexError] new error instance
      def initialize(vertices = 3)
        @vertices = vertices
      end

      private

      # Log level of the error.
      # @return [Symbol] log level
      def level
        :error
      end

      # Composed error message.
      # @return [String] error message
      def message
        "Incorrect number of vertices. Must contain a minimum of #{@vertices} vertices."
      end
    end
  end

  # Standard error wrapper for LUTS
  class ScriptError < ::StandardError
  end
end
