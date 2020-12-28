# frozen_string_literal: true

require 'eva'
require 'parser/EvaParser'

RSpec.describe Eva do
  subject(:eva_machine) { Eva.new }

  describe '#eval increment expression' do
    let(:expr) do
      '(begin

        (var result 0)

        (++ result)

        result

      )'
    end
    let(:result) { 1 }

    it { expect(expr).to be_evaluated_to(result) }
  end
end
