# frozen_string_literal: true

require 'eva'
require 'parser/EvaParser'

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

        it { expect(eva_machine.eval(expr)).to eq(expr) }
      end

      context 'when expression is a double quoted string' do
        let(:expr) { '"string"' }

        it { expect(eva_machine.eval(expr)).to eq('string') }
      end
    end

    context 'when math operations' do
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

    context 'when variable declaration' do
      let(:expr) { '(var x 1)' }
      let(:result) { 1 }

      context 'when declares variable' do
        it { expect(expr).to be_evaluated_to(result) }
      end

      context 'when gets variable value by name' do
        before do
          parsed_expr = EvaParser.parse(expr)
          eva_machine.eval(parsed_expr)
        end

        it { expect('x').to be_evaluated_to(result) }
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

        it { expect(expr).to be_evaluated_to(result) }

        context 'when value is predefined value' do
          let(:expr) { '(var isUser true)' }
          let(:result) { true }

          it { expect(expr).to be_evaluated_to(result) }
        end
      end

      context 'when value is calculated expression' do
        let(:expr) { '(var y (* 2 3))' }
        let(:result) { 6 }

        it { expect(expr).to be_evaluated_to(result) }
      end
    end

    context 'when block expression' do
      let(:expr) do
        '(begin
           (var x 10)
           (var y 20)
           (+ (* x y) 30)
        )'
      end
      let(:result) { 230 }

      it { expect(expr).to be_evaluated_to(result) }
    end

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

    context 'when variable in nested block accesses varible in outer block expression' do
      let(:expr) do
        '(begin
           (var value 10)
           (var result (begin (var x (+ value 10)) x))
           result
         )'
      end
      let(:result) { 20 }

      it { expect(expr).to be_evaluated_to(result) }
    end

    context 'when assigns variable in nested block expression' do
      let(:expr) do
        '(begin
           (var data 10)
           (begin (set data 100))
           data
         )'
      end
      let(:result) { 100 }

      it { expect(expr).to be_evaluated_to(result) }
    end

    context 'when condition expression' do
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

    context 'when while loop expression' do
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
end
