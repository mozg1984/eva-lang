# frozen_string_literal: true

require 'eva'
require 'parser/EvaParser'

RSpec.describe Eva do
  subject(:eva_machine) { Eva.new }

  describe '#eval user-defined function expression' do
    context 'when simple body' do
      let(:expr) do
        '(begin

          (def square (x)
            (* x x))

          (square 4)

        )'
      end
      let(:result) { 16 }

      it { expect(expr).to be_evaluated_to(result) }
    end

    context 'when complex body' do
      let(:expr) do
        '(begin

          (def calc (x y)
            (begin
              (var z 30)
              (+ (* x y) z)
            ))

          (calc 10 20)

        )'
      end
      let(:result) { 230 }

      it { expect(expr).to be_evaluated_to(result) }
    end

    context 'when closure' do
      let(:expr) do
        '(begin

          (var value 100)

          (def calc (x y)
            (begin
              (var z (+ x y))

              (def inner (foo)
                (+ (+ foo z) value))

              inner
            ))

          (var fn (calc 10 20))

          (fn 30)

        )'
      end
      let(:result) { 160 }

      it { expect(expr).to be_evaluated_to(result) }
    end

    context 'when recursive function' do
      let(:expr) do
        '(begin

          (def factorial (x)
            (if (= x 1)
              1
              (* x (factorial (- x 1)))))

          (factorial 5)

        )'
      end
      let(:result) { 120 }

      it { expect(expr).to be_evaluated_to(result) }
    end
  end
end
