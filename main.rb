# frozen_string_literal: true

require_relative 'receipt_generator'

if __FILE__ == $PROGRAM_NAME
  puts "Enter your items (e.g., '2 imported book at 12.49'), one per line. Press enter on an empty line to finish:"

  input_lines = []
  while (line = gets&.strip) && !line.empty?
    input_lines << line
  end

  generator = ReceiptGenerator.new(input_lines: input_lines)
  puts generator.call
end
