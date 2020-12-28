# frozen_string_literal: true

require 'environment/Global'
require 'Transformer'

# Eva interpreter.
class Eva
  # Creates an Eva instance with the global environment.
  def initialize(global = Environment::Global.build)
    @global = global
    @transformer = Transformer.new
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

    # Function declaration:
    # Syntactic sugar for assigning lambda to variable:
    if expr&.[](0) == 'def'
      # JIT-transpile to a variable declaration
      var_exp = @transformer.transform_def_to_variable(expr)
      return self.eval(var_exp, env)
    end

    # Switch-expression:
    # Syntactic sugar for nested if-expressions
    if expr&.[](0) == 'switch'
      if_exp = @transformer.transform_switch_to_if(expr)
      return self.eval(if_exp, env)
    end

    # For-loop: (for init condition modifier body)
    # Syntactic sugar for: (begin init (while condition (begin body modifier)))
    if expr&.[](0) == 'for'
      while_exp = @transformer.transform_for_to_while(expr)
      return self.eval(while_exp, env)
    end

    # Increment:
    # Syntactic sugar for variable updation
    if expr&.[](0) == '++'
      set_exp = @transformer.transform_inc_to_set(expr)
      return self.eval(set_exp, env)
    end

    # Decrement:
    # Syntactic sugar for variable updation
    if expr&.[](0) == '--'
      set_exp = @transformer.transform_dec_to_set(expr)
      return self.eval(set_exp, env)
    end

    # Increment by value:
    # Syntactic sugar for variable updation
    if expr&.[](0) == '+='
      set_exp = @transformer.transform_inc_val_to_set(expr)
      return self.eval(set_exp, env)
    end

    # Decrement by value:
    # Syntactic sugar for variable updation
    if expr&.[](0) == '-='
      set_exp = @transformer.transform_dec_val_to_set(expr)
      return self.eval(set_exp, env)
    end

    # Lambda function calls:
    if expr&.[](0) == 'lambda'
      _tag, params, body = expr

      return {
        params: params,
        body: body,
        env: env # Closure!
      }
    end

    # Function calls:
    if expr.is_a?(Array)
      fn = self.eval(expr[0], env)
      args = expr[1..-1].map { |arg| self.eval(arg, env) }

      # 1. Native function:
      return fn.call(*args) if fn.is_a?(Proc)

      # 2. User-defined function:
      activation_record = {}
      fn[:params].each_with_index do |param, index|
        activation_record[param] = args[index]
      end

      activation_env = Environment.new(
        activation_record,
        fn[:env]
      )

      return _eval_body(fn[:body], activation_env)
    end

    raise NotImplementedError, expr
  end

  def _eval_body(body, env)
    return _eval_block(body, env) if body&.[](0) == 'begin'

    self.eval(body, env)
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
