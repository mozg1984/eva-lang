# frozen_string_literal: true

require 'eva'
require 'parser/EvaParser'

RSpec.describe Eva do
  subject(:eva_machine) { Eva.new }

  describe '#eval math operation expression' do
    context 'when addition' do
      let(:expr) { '(+ 1 2)' }
      let(:result) { 3 }

      it { expect(expr).to be_evaluated_to(result) }
    end

    context 'when subtraction' do
      let(:expr) { '(- 2 1)' }
      let(:result) { 1 }

      it { expect(expr).to be_evaluated_to(result) }
    end

    context 'when multiplication' do
      let(:expr) { '(* 2 3)' }
      let(:result) { 6 }

      it { expect(expr).to be_evaluated_to(result) }
    end

    context 'when devision' do
      let(:expr) { '(/ 6 3)' }
      let(:result) { 2 }

      it { expect(expr).to be_evaluated_to(result) }
    end

    context 'when multiple operations' do
      let(:expr) { '(+ (- 5 3) (* 2 4))' }
      let(:result) { 10 }

      it { expect(expr).to be_evaluated_to(result) }
    end
  end
end
