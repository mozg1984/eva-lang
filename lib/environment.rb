# frozen_string_literal: true

# Environment: names storage.
class Environment
  # Creates an environment with the given record.
  def initialize(record = {})
    @record = record
  end

  # Creates a variable with the given name and value.
  def define(name, value)
    @record[name] = value
    value
  end

  # Returns the value of a defined variable, or throws
  # if the variable is not defined.
  def lookup(name)
    raise "Variable \"#{name}\" is not defined" unless @record.key?(name)

    @record[name]
  end
end
