# frozen_string_literal: true

require_relative '../receipt_generator'

RSpec.describe ReceiptGenerator do
  subject { described_class.new(input_lines: input_lines).call }

  describe '#call' do
    context 'example input 1' do
      let(:input_lines) do
        [
          '2 book at 12.49',
          '1 music CD at 14.99',
          '1 chocolate bar at 0.85'
        ]
      end

      let(:expected_result) do
        <<~RECEIPT
          2 book: 24.98
          1 music CD: 16.49
          1 chocolate bar: 0.85
          Sales Taxes: 1.50
          Total: 42.32
        RECEIPT
      end

      it 'returns the correct receipt' do
        is_expected.to eq(expected_result)
      end
    end

    context 'example input 2' do
      let(:input_lines) do
        [
          '1 imported box of chocolates at 10.00',
          '1 imported bottle of perfume at 47.50'
        ]
      end

      let(:expected_result) do
        <<~RECEIPT
          1 imported box of chocolates: 10.50
          1 imported bottle of perfume: 54.65
          Sales Taxes: 7.65
          Total: 65.15
        RECEIPT
      end

      it 'returns the correct receipt' do
        is_expected.to eq(expected_result)
      end
    end

    context 'example input 3' do
      let(:input_lines) do
        [
          '1 imported bottle of perfume at 27.99',
          '1 bottle of perfume at 18.99',
          '1 packet of headache pills at 9.75',
          '3 imported boxes of chocolates at 11.25'
        ]
      end

      let(:expected_result) do
        <<~RECEIPT
          1 imported bottle of perfume: 32.19
          1 bottle of perfume: 20.89
          1 packet of headache pills: 9.75
          3 imported boxes of chocolates: 35.55
          Sales Taxes: 7.90
          Total: 98.38
        RECEIPT
      end

      it 'returns the correct receipt' do
        is_expected.to eq(expected_result)
      end
    end
  end
end
