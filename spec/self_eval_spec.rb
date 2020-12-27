# frozen_string_literal: true

require 'eva'
require 'parser/EvaParser'

RSpec.describe Eva do
  subject(:eva_machine) { Eva.new }

  describe '#eval with self eval expression' do
    context 'when no expression' do
      let(:expr) { nil }

      it 'raises error' do
        expect { eva_machine.eval(expr) }.to raise_error(NotImplementedError)
      end
    end

    context 'when expression is numeric' do
      let(:expr) { 1 }

      it { expect(eva_machine.eval(expr)).to eq(expr) }
    end

    context 'when expression is a double quoted string' do
      let(:expr) { '"string"' }

      it { expect(eva_machine.eval(expr)).to eq('string') }
    end
  end
end
