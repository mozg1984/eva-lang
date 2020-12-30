# frozen_string_literal: true

# Environment: names storage.
class Environment
  attr_reader :record
  attr_reader :parent

  # Creates an environment with the given record.
  def initialize(record = {}, parent = nil)
    @record = record
    @parent = parent
  end

  # Creates a variable with the given name and value.
  def define(name, value)
    @record[name] = value
    value
  end

  # Updates an existing variable.
  def assign(name, value)
    resolve(name).record[name] = value
    value
  end

  # Returns the value of a defined variable, or throws
  # if the variable is not defined.
  def lookup(name)
    resolve(name).record[name]
  end

  # Returns specific environment in which a variable is defined, or
  # throws if a variable is not defined
  def resolve(name)
    return self if @record.key?(name)

    raise "Variable \"#{name}\" is not defined" if @parent.nil?

    @parent.resolve(name)
  end
end
