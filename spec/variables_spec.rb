# frozen_string_literal: true

require 'eva'
require 'parser/EvaParser'

RSpec.describe Eva do
  subject(:eva_machine) { Eva.new }

  describe '#eval expression with variables' do
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
  end
end
