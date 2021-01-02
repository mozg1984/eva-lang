# frozen_string_literal: true

require 'eva'
require 'parser/EvaParser'

RSpec.describe Eva do
  subject(:eva_machine) { Eva.new }

  describe '#eval built-in function expression' do
    context 'when math operations' do
      it { expect('(+ 1 2)').to be_evaluated_to(3) }
      it { expect('(- 2 1)').to be_evaluated_to(1) }
      it { expect('(* 2 3)').to be_evaluated_to(6) }
      it { expect('(/ 6 3)').to be_evaluated_to(2) }
    end

    context 'when condition operations' do
      it { expect('(> 1 2)').to be_evaluated_to(false) }
      it { expect('(>= 2 1)').to be_evaluated_to(true) }
      it { expect('(= 2 2)').to be_evaluated_to(true) }
      it { expect('(< 6 3)').to be_evaluated_to(false) }
      it { expect('(<= 3 6)').to be_evaluated_to(true) }
    end

    context 'when logical operations' do
      it { expect('(or false true)').to be_evaluated_to(true) }
      it { expect('(or false false)').to be_evaluated_to(false) }
      it { expect('(and true false)').to be_evaluated_to(false) }
      it { expect('(and true true)').to be_evaluated_to(true) }
      it { expect('(not false)').to be_evaluated_to(true) }
    end

    context 'when print function' do
      let(:expr) { ['print', '"Hello,"', '"world"'] }
      let(:result) { "Hello,\nworld\n" }

      it { expect { eva_machine.eval(expr) }.to output(result).to_stdout }
    end
  end
end
