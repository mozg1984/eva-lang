# frozen_string_literal: true

require 'eva'
require 'parser/EvaParser'

RSpec.describe Eva do
  subject(:eva_machine) { Eva.new }

  describe '#eval class expression' do
    let(:expr) do
      '(begin

        (class Point null
          (begin

            (def constructor (this x y)
              (begin
                (set (prop this x) x)
                (set (prop this y) y)))

            (def calc (this)
              (+ (prop this x) (prop this y)))))

        (var p (new Point 10 20))

        ((prop p calc) p)

      )'
    end
    let(:result) { 30 }

    it { expect(expr).to be_evaluated_to(result) }
  end
end
