# frozen_string_literal: true

require 'eva'

RSpec.describe Eva do
  subject(:eva_machine) { Eva.new }

  describe '#eval' do
    context 'when no expression' do
      let(:expr) { nil }

      it 'raises error' do
        expect { eva_machine.eval(expr) }.to raise_error(NotImplementedError)
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

    context 'when variable declaration' do
      let(:expr) { ['var', variable_name, variable_value] }
      let(:variable_name) { 'x' }
      let(:variable_value) { 1 }

      context 'when declares variable' do
        it do
          expect(eva_machine.eval(expr)).to eq(variable_value)
        end
      end

      context 'when gets variable value' do
        before { eva_machine.eval(expr) }

        it do
          expect(eva_machine.eval(variable_name)).to eq(variable_value)
        end
      end

      context 'when predefined variables' do
        subject(:eva_machine) { Eva.new(environment) }

        let(:environment) do
          Environment.new(
            'null' => nil,
            'true' => true,
            'false' => false,
            'VERSION' => '0.1'
          )
        end
        let(:expr) { 'VERSION' }
        let(:result) { '0.1' }

        it do
          expect(eva_machine.eval(expr)).to eq(result)
        end

        context 'when value is predefined value' do
          let(:expr) { %w[var isUser true] }
          let(:result) { true }

          it do
            expect(eva_machine.eval(expr)).to eq(result)
          end
        end
      end

      context 'when value is calculated expression' do
        let(:expr) { ['var', 'y', ['*', 2, 3]] }
        let(:result) { 6 }

        it do
          expect(eva_machine.eval(expr)).to eq(result)
        end
      end
    end

    context 'when block expression' do
      let(:expr) do
        ['begin',
          ['var', 'x', 10],
          ['var', 'y', 20],
          ['+', ['*', 'x', 'y'], 30]
        ]
      end
      let(:result) { 230 }

      it do
        expect(eva_machine.eval(expr)).to eq(result)
      end
    end

    context 'when block with nested block expression' do
      let(:expr) do
        ['begin',
          ['var', 'x', 10],
          ['begin',
            ['var', 'x', 20],
            'x'
          ],
          'x'
        ]
      end
      let(:result) { 10 }

      it do
        expect(eva_machine.eval(expr)).to eq(result)
      end
    end

    context 'when variable in nested block accesses varible in outer block expression' do
      let(:expr) do
        ['begin',
          ['var', 'value', 10],
          ['var', 'result', ['begin',
            ['var', 'x', ['+', 'value', 10]],
            'x'
          ]],
          'result'
        ]
      end
      let(:result) { 20 }

      it do
        expect(eva_machine.eval(expr)).to eq(result)
      end
    end

    context 'when assigns variable in nested block expression' do
      let(:expr) do
        ['begin',
          ['var', 'data', 10],
          ['begin',
            ['set', 'data', 100]
          ],
          'data'
        ]
      end
      let(:result) { 100 }

      it do
        expect(eva_machine.eval(expr)).to eq(result)
      end
    end
  end
end
