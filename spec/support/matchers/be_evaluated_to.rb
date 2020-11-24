# frozen_string_literal: true

RSpec::Matchers.define :be_evaluated_to do |result|
  match do |code|
    expr = EvaParser.parse(code)
    eva_machine.eval(expr) == result
  end
end
