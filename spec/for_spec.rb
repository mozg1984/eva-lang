# frozen_string_literal: true

require 'eva'
require 'parser/EvaParser'

RSpec.describe Eva do
  subject(:eva_machine) { Eva.new }

  describe '#eval for expression' do
    let(:expr) do
      '(begin

        (var result 0)

        (for (var i 0) (< i 5) (set i (+ i 1))
          (set result (+ result i)))

        result

      )'
    end
    let(:result) { 10 }

    it { expect(expr).to be_evaluated_to(result) }
  end
end
