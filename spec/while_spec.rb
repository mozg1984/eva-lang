# frozen_string_literal: true

require 'eva'
require 'parser/EvaParser'

RSpec.describe Eva do
  subject(:eva_machine) { Eva.new }

  describe '#eval while expression' do
    let(:expr) do
      '(begin

        (var counter 0)
        (var result 0)

        (while (< counter 10)
          (begin
            (set result (+ result 1))
            (set counter (+ counter 1))))

        result
      )'
    end
    let(:result) { 10 }

    it { expect(expr).to be_evaluated_to(result) }
  end
end
