# frozen_string_literal: true

# Eva interpreter.
class Eva
  def eval(expr)
    # Self-evaluating expressions:
    return expr if number?(expr)
    return expr[1..-2] if string?(expr)

    # Math operations:
    return self.eval(expr[1]) * self.eval(expr[2]) if expr&.[](0) == '*'
    return self.eval(expr[1]) / self.eval(expr[2]) if expr&.[](0) == '/'
    return self.eval(expr[1]) + self.eval(expr[2]) if expr&.[](0) == '+'
    return self.eval(expr[1]) - self.eval(expr[2]) if expr&.[](0) == '-'

    raise 'Not implemented'
  end

  def number?(expr)
    expr.is_a?(Numeric)
  end

  def string?(expr)
    expr.is_a?(String) && expr[0] == '"' && expr[-1] == '"'
  end
end
