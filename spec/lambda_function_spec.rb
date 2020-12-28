# frozen_string_literal: true

require 'eva'
require 'parser/EvaParser'

RSpec.describe Eva do
  subject(:eva_machine) { Eva.new }

  describe '#eval lambda function expression' do
    context 'when pass lambda as a callback' do
      let(:expr) do
        '(begin

          (def on_click (callback)
            (begin
              (var x 10)
              (var y 20)
              (callback (+ x y))))

          (on_click (lambda (data) (* data 10)))

        )'
      end
      let(:result) { 300 }

      it { expect(expr).to be_evaluated_to(result) }
    end

    context 'when immediately-invoked lambda expression (IILE)' do
      let(:expr) do
        '((lambda (x) (* x x)) 2)'
      end
      let(:result) { 4 }

      it { expect(expr).to be_evaluated_to(result) }
    end

    context 'when save lambda to a variable' do
      let(:expr) do
        '(begin
           (var square (lambda (x) (* x x)))
           (square 2)
        )'
      end
      let(:result) { 4 }

      it { expect(expr).to be_evaluated_to(result) }
    end
  end
end
