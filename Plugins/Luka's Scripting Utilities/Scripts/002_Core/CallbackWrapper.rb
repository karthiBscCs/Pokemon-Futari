#===============================================================================
#  Luka's Scripting Utilities
#
#  New callback wrapper with variable passing
#===============================================================================
# Callback wrapper that executes a block in an isolated context, with
# keyword arguments exposed as instance variables.
class CallbackWrapper
  # Instanciates a CallbackWrapper with the specified params
  # @param kwargs [Hash] params exposed as instance variables to the block
  # @param block [Proc] callback block to wrap
  # @return [CallbackWrapper] new instance with params set
  def self.with_params(**kwargs, &block)
    new(&block).set_params(**kwargs)
  end

  # Callback constructor
  # @param block [Proc] callback block to wrap
  # @return [CallbackWrapper] new instance
  def initialize(&block)
    @block = block
    @wrapper = Object.new
  end

  # Execute callback
  # @return [Object] result of the callback block, or nil if no block is set
  def execute
    return unless block

    wrapper.instance_exec(&block)
  end

  # Set params as instance variables
  # @param kwargs [Hash] params exposed as instance variables to the block
  # @return [CallbackWrapper] self
  def set_params(**kwargs)
    kwargs.each do |key, value|
      wrapper.instance_variable_set("@#{key}", value)
    end

    self
  end

  private

  # @return [Proc] wrapped callback block
  attr_reader :block
  # @return [Object] isolated execution context for the block
  attr_reader :wrapper
end
