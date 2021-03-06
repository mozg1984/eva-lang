# frozen_string_literal: true

require_relative '../environment.rb'

class Environment
  class Global
    def self.build
      Environment.new(
        'null' => nil,

        'true' => true,
        'false' => false,

        'VERSION' => '0.1',

        # Operators:
        '+' => ->(op1, op2) { op1 + op2 },
        '*' => ->(op1, op2) { op1 * op2 },
        '-' => ->(op1, op2 = nil) { op2.nil? ? -op1 : op1 - op2 },
        '/' => ->(op1, op2) { op1 / op2 },

        # Comparison operators:
        '>' => ->(op1, op2) { op1 > op2 },
        '>=' => ->(op1, op2) { op1 >= op2 },
        '=' => ->(op1, op2) { op1 == op2 },
        '<' => ->(op1, op2) { op1 < op2 },
        '<=' => ->(op1, op2) { op1 <= op2 },

        # Logical operators
        'or' => ->(op1, op2) { op1 || op2 },
        'and' => ->(op1, op2) { op1 && op2 },
        'not' => ->(op) { !op },

        # Console output:
        'print' => ->(*args) { puts args }
      )
    end
  end
end
