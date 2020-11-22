# frozen_string_literal: true

require 'Environment'

# Eva interpreter.
class Eva
  # Creates an Eva instance with the global environment.
  def initialize(global = Environment.new)
    @global = global
  end

  # Evaluates an expression in the given environment.
  def eval(expr, env = @global)
    # Self-evaluating expressions:
    return expr if number?(expr)
    return expr[1..-2] if string?(expr)

    # Math operations:
    return self.eval(expr[1]) * self.eval(expr[2]) if expr&.[](0) == '*'
    return self.eval(expr[1]) / self.eval(expr[2]) if expr&.[](0) == '/'
    return self.eval(expr[1]) + self.eval(expr[2]) if expr&.[](0) == '+'
    return self.eval(expr[1]) - self.eval(expr[2]) if expr&.[](0) == '-'

    # Variable declaration:
    if expr&.[](0) == 'var'
      _, name, value = expr
      return env.define(name, self.eval(value))
    end

    # Variable access:
    return env.lookup(expr) if variable?(expr)

    raise NotImplementedError, expr
  end

  def number?(expr)
    expr.is_a?(Numeric)
  end

  def string?(expr)
    expr.is_a?(String) && expr[0] == '"' && expr[-1] == '"'
  end

  def variable?(expr)
    expr.is_a?(String) && (/^[a-zA-Z][a-zA-Z0-9_]*$/ =~ expr).zero?
  end
end
