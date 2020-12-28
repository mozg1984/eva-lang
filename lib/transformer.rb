# frozen_string_literal: true

# AST transformer
class Transformer
  # Translates `def`-expression (function declaration)
  # into a variable declaration with a lambda expression
  def transform_def_to_variable(def_expr)
    _tag, name, params, body = def_expr
    ['var', name, ['lambda', params, body]]
  end

  def transform_switch_to_if(switch_expr)
    _tag, *cases = switch_expr

    if_expr = ['if', nil, nil, nil]
    current = if_expr

    (0..(cases.size - 2)).each do |i|
      current_cond, current_block = cases[i]

      current[1] = current_cond
      current[2] = current_block

      next_case = cases[i + 1]
      next_cond, next_block = next_case

      current[3] = next_cond == 'else' ? next_block : ['if']
      current = current[3]
    end

    if_expr
  end

  def transform_inc_to_set(inc_expr)
    _tag, expr = inc_expr
    ['set', expr, ['+', expr, 1]]
  end

  def transform_dec_to_set(dec_expr)
    _tag, expr = dec_expr
    ['set', expr, ['-', expr, 1]]
  end

  def transform_inc_val_to_set(inc_expr)
    _tag, expr, val = inc_expr
    ['set', expr, ['+', expr, val]]
  end

  def transform_dec_val_to_set(dec_expr)
    _tag, expr, val = dec_expr
    ['set', expr, ['-', expr, val]]
  end
end
