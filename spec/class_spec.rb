# frozen_string_literal: true

require 'eva'
require 'parser/EvaParser'

RSpec.describe Eva do
  let(:class_expr) do
    '(class Point null
          (begin

            (def constructor (this x y)
              (begin
                (set (prop this x) x)
                (set (prop this y) y)))

            (def calc (this)
              (+ (prop this x) (prop this y)))))'
  end

  subject(:eva_machine) { Eva.new }

  describe '#eval class expression' do
    let(:expr) do
      "#{class_expr}

        (var p (new Point 10 20))

        ((prop p calc) p)"
    end
    let(:result) { 30 }

    it { expect(expr).to be_evaluated_to(result) }

    context 'when the class is inherited' do
      let(:expr) do
        "#{class_expr}

        (class Point3D Point
            (begin

              (def constructor (this x y z)
                (begin
                  ((prop super constructor) this x y)
                  (set (prop this z) z)))

              (def calc (this)
                (+ ((prop super calc) this)
                   (prop this z)))))

          (var p (new Point3D 10 20 30))

          ((prop p calc) p)"
      end
      let(:result) { 60 }

      it { expect(expr).to be_evaluated_to(result) }
    end
  end
end
