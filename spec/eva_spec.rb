# frozen_string_literal: true

require 'eva'

RSpec.describe Eva do
  subject(:eva_machine) { Eva.new }

  describe '#eval' do
    context 'when no expression' do
      let(:expr) { nil }

      it 'raises error' do
        expect { eva_machine.eval(expr) }.to raise_error('Not implemented')
      end
    end

    context 'when self-evaluating expressions' do
      context 'when expression is numeric' do
        let(:expr) { 1 }

        it do
          expect(eva_machine.eval(expr)).to eq(expr)
        end
      end

      context 'when expression is a double quoted string' do
        let(:expr) { '"string"' }

        it do
          expect(eva_machine.eval(expr)).to eq('string')
        end
      end
    end

    context 'when math operations' do
      context 'when addition' do
        let(:expr) { ['+', 1, 2] }
        let(:result) { 3 }

        it do
          expect(eva_machine.eval(expr)).to eq(result)
        end
      end

      context 'when subtraction' do
        let(:expr) { ['-', 2, 1] }
        let(:result) { 1 }

        it do
          expect(eva_machine.eval(expr)).to eq(result)
        end
      end

      context 'when multiplication' do
        let(:expr) { ['*', 2, 3] }
        let(:result) { 6 }

        it do
          expect(eva_machine.eval(expr)).to eq(result)
        end
      end

      context 'when devision' do
        let(:expr) { ['/', 6, 3] }
        let(:result) { 2 }

        it do
          expect(eva_machine.eval(expr)).to eq(result)
        end
      end

      context 'when multiple operations' do
        let(:expr) { ['+', ['-', 5, 3], ['*', 2, 4]] }
        let(:result) { 10 }

        it do
          expect(eva_machine.eval(expr)).to eq(result)
        end
      end
    end
  end
end
