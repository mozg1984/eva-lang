# frozen_string_literal: true

RSpec::Matchers.define :be_evaluated_to do |result|
  match do |code|
    expr = EvaParser.parse("(begin #{code})")
    eva_machine.eval_global(expr) == result
  end
end
