# frozen_string_literal: true

require 'eva'
require 'parser/EvaParser'

RSpec.describe Eva do
  subject(:eva_machine) { Eva.new }

  describe '#eval decrement value expression' do
    let(:expr) do
      '(begin

        (var result 5)

        (-= result 5)

        result

      )'
    end
    let(:result) { 0 }

    it { expect(expr).to be_evaluated_to(result) }
  end
end
