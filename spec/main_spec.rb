# frozen_string_literal: true

require 'open3'

RSpec.describe 'main.rb CLI' do
  let(:input) do
    <<~INPUT
      2 book at 12.49
      1 music CD at 14.99
      1 chocolate bar at 0.85
    INPUT
  end

  let(:expected_output) do
    <<~RECEIPT
      2 book: 24.98
      1 music CD: 16.49
      1 chocolate bar: 0.85
      Sales Taxes: 1.50
      Total: 42.32
    RECEIPT
  end

  it 'processes user input and outputs receipt' do
    stdout, _stderr, _status = Open3.capture3('ruby main.rb', stdin_data: input)
    expect(stdout).to match(expected_output)
  end
end
