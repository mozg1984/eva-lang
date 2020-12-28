# frozen_string_literal: true

# AST transformer
class Transformer
  # Translates `def`-expression (function declaration)
  # into a variable declaration with a lambda expression
  def transform_def_to_variable(def_expr)
    _tag, name, params, body = def_expr
    ['var', name, ['lambda', params, body]]
  end
end
