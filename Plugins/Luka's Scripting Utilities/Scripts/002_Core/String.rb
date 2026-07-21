#===============================================================================
#  Luka's Scripting Utilities
#
#  Core extensions for the `String` class
#===============================================================================
# Core extensions for the `String` class with constantizing, case
# conversion and message color tagging helpers.
class ::String
  # Turns string into an actual Ruby object
  # @return [Object] resolved constant
  def constantize
    Object.const_get(self)
  end

  # Turns string into an actual Ruby object if exists
  # @return [Object, nil] resolved constant, or nil if undefined
  def safe_constantize
    Object.const_get(self) if Object.const_defined?(self)
  end

  # Capitalizes the first letter of the string.
  # @return [String] capitalized first letter
  def capitalize
    sub(/^\w/) { ::Regexp.last_match(0).upcase }
  end

  # Converts an underscored string to camel case.
  # @return [String] to camel case
  def camelize
    downcase.split('_').map(&:capitalize).join('')
  end

  # Converts a camel cased string to snake case.
  # @return [String] to snake case
  def underscore
    return downcase if match(/\A[A-Z]+\z/)

    gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').gsub(/([a-z])([A-Z])/, '\1_\2').tr('-', '_').downcase
  end

  # Strips leading module namespaces from a constant name.
  # @return [String] without leading module names
  def demodulize
    split('::').last
  end

  # Checks whether the string is empty or contains only spaces.
  # @return [Boolean] true if string is empty or whitespace only
  def blank?
    eql?('') || chars.all? { |c| c.eql?(' ') }
  end

  # Checks whether the string has any non-whitespace content.
  # @return [Boolean] true if string is not blank
  def present?
    !blank?
  end

  # Returns the indefinite article appropriate for the string.
  # @return [String] 'a' or 'an' depending on the first letter
  def preposition
    first = chars.first&.downcase
    return 'a' unless first
    return 'an' if ['a', 'e', 'i', 'o', 'u'].any? { |char| first.eql?(char) }

    'a'
  end

  # Tag string with color values
  # @return [String] string wrapped in red color tags
  def red
    "#{shadowctag(Color.new(232, 32, 16), Color.new(248, 168, 184))}#{self}</c2>"
  end

  # Tags string with green color values.
  # @return [String] string wrapped in green color tags
  def green
    "#{shadowctag(Color.new(96, 176, 72), Color.new(174, 208, 144))}#{self}</c2>"
  end

  # Tags string with blue color values.
  # @return [String] string wrapped in blue color tags
  def blue
    "#{shadowctag(Color.new(0, 112, 248), Color.new(120, 184, 232))}#{self}</c2>"
  end

  # Tags string with cyan color values.
  # @return [String] string wrapped in cyan color tags
  def cyan
    "#{shadowctag(Color.new(72, 216, 216), Color.new(168, 224, 224))}#{self}</c2>"
  end

  # Tags string with magenta color values.
  # @return [String] string wrapped in magenta color tags
  def magenta
    "#{shadowctag(Color.new(208, 56, 184), Color.new(232, 160, 224))}#{self}</c2>"
  end

  # Tags string with yellow color values.
  # @return [String] string wrapped in yellow color tags
  def yellow
    "#{shadowctag(Color.new(232, 208, 32), Color.new(248, 232, 136))}#{self}</c2>"
  end

  # Tags string with purple color values.
  # @return [String] string wrapped in purple color tags
  def purple
    "#{shadowctag(Color.new(114, 64, 232), Color.new(184, 168, 224))}#{self}</c2>"
  end

  # Tags string with orange color values.
  # @return [String] string wrapped in orange color tags
  def orange
    "#{shadowctag(Color.new(248, 152, 24), Color.new(248, 200, 152))}#{self}</c2>"
  end
end
