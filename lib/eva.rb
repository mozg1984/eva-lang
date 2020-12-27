# frozen_string_literal: true

require 'environment/Global'

# Eva interpreter.
class Eva
  # Creates an Eva instance with the global environment.
  def initialize(global = Environment::Global.build)
    @global = global
  end

  # Evaluates an expression in the given environment.
  def eval(expr, env = @global)
    # Self-evaluating expressions:
    return expr if number?(expr)
    return expr[1..-2] if string?(expr)

    # Block: sequence of expressions
    if expr&.[](0) == 'begin'
      block_env = Environment.new({}, env)
      return _eval_block(expr, block_env)
    end

    # Variable declaration:
    if expr&.[](0) == 'var'
      _, name, value = expr
      return env.define(name, self.eval(value, env))
    end

    # Variable updation:
    if expr&.[](0) == 'set'
      _, name, value = expr
      return env.assign(name, self.eval(value, env))
    end

    # Variable access:
    return env.lookup(expr) if variable?(expr)

    # if-expression:
    if expr&.[](0) == 'if'
      _tag, condition, consequent, alternate = expr

      return self.eval(consequent, env) if self.eval(condition, env)

      return self.eval(alternate, env)
    end

    # while-expression:
    if expr&.[](0) == 'while'
      result = nil

      _tag, condition, body = expr
      while self.eval(condition, env) do result = self.eval(body, env) end

      return result
    end

    # Function calls:
    if expr.is_a?(Array)
      fn = self.eval(expr[0])
      args = expr[1..-1].map { |arg| self.eval(arg, env) }

      # 1. Native function:

      return fn.call(*args) if fn.is_a?(Proc)
    end

    raise NotImplementedError, expr
  end

  def _eval_block(block, env)
    result = nil

    _tag, *expressions = block
    expressions.each { |expr| result = self.eval(expr, env) }

    result
  end

  def number?(expr)
    expr.is_a?(Numeric)
  end

  def string?(expr)
    expr.is_a?(String) && expr[0] == '"' && expr[-1] == '"'
  end

  def variable?(expr)
    expr.is_a?(String) && (/^[+\-*\/<>=a-zA-Z0-9_]*$/ =~ expr)&.zero?
  end
end
