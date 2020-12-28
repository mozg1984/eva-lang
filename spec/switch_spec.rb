# frozen_string_literal: true

require 'eva'
require 'parser/EvaParser'

RSpec.describe Eva do
  subject(:eva_machine) { Eva.new }

  describe '#eval condition expression' do
    let(:expr) do
      '(begin

        (var x 10)

        (switch ((= x 10) 100)
                ((> x 10) 200)
                (else     300))

      )'
    end
    let(:result) { 100 }

    it { expect(expr).to be_evaluated_to(result) }
  end
end
