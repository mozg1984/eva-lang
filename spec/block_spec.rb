# frozen_string_literal: true

require 'eva'
require 'parser/EvaParser'

RSpec.describe Eva do
  subject(:eva_machine) { Eva.new }

  describe '#eval block expression' do
    let(:expr) do
      '(begin
          (var x 10)
          (var y 20)
          (+ (* x y) 30)
      )'
    end
    let(:result) { 230 }

    it { expect(expr).to be_evaluated_to(result) }

    context 'when block with nested block expression' do
      let(:expr) do
        '(begin
           (var x 10)
           (begin (var x 20) x)
           x
         )'
      end
      let(:result) { 10 }

      it { expect(expr).to be_evaluated_to(result) }
    end
  end
end
