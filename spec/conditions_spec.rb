# frozen_string_literal: true

require 'eva'
require 'parser/EvaParser'

RSpec.describe Eva do
  subject(:eva_machine) { Eva.new }

  describe '#eval condition expression' do
    let(:expr) do
      '(begin

        (var x 10)
        (var y 0)

        (if (> x 10)
          (set y 20)
          (set y 30))

        y
      )'
    end
    let(:result) { 30 }

    it { expect(expr).to be_evaluated_to(result) }
  end
end
