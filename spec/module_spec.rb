# frozen_string_literal: true

require 'eva'
require 'parser/EvaParser'

RSpec.describe Eva do
  let(:module_expr) do
    '(module Math
      (begin

        (def abs (value)
          (if (< value 0)
              (- value)
              value))

        (def square (x)
          (* x x))

        (var MAX_VALUE 4611686018427387903)
      )
    )'
  end
  subject(:eva_machine) { Eva.new }

  describe '#eval module expression' do
    let(:expr) do
      "
      #{module_expr}

      ((prop Math abs) (- 10))
      "
    end
    let(:result) { 10 }

    it { expect(expr).to be_evaluated_to(result) }

    context 'when extracts method from module' do
      let(:expr) do
        "
        #{module_expr}

        (var abs (prop Math abs))

        (abs (- 10))
        "
      end
      let(:result) { 10 }

      it { expect(expr).to be_evaluated_to(result) }
    end

    context 'when gets constant from module' do
      let(:expr) do
        "
        #{module_expr}

        (prop Math MAX_VALUE)
        "
      end
      let(:result) { 4_611_686_018_427_387_903 }

      it { expect(expr).to be_evaluated_to(result) }
    end
  end
end
