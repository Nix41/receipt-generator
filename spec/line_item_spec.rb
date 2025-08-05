# frozen_string_literal: true

require_relative '../line_item'

RSpec.describe LineItem do
  subject(:line_item) { described_class.new(quantity: quantity, name: name, price: price, imported: imported) }

  let(:name) { 'book' }
  let(:imported) { false }
  let(:price) { 10.00 }
  let(:quantity) { 1 }
  let(:input_line) { '1 book at 12.49' }

  describe '.parse' do
    subject { described_class.parse(input_line) }

    context 'when line has valid format' do
      let(:input_line) { '1 book at 12.49' }

      it 'creates a LineItem with correct attributes' do
        is_expected.to be_a(LineItem)
                   .and have_attributes(quantity: 1, name: 'book', price: 12.49, imported: false)
      end
    end

    context 'when line has valid format with imported item' do
      let(:input_line) { '1 imported book at 12.49' }

      it 'creates a LineItem with correct attributes' do
        is_expected.to be_a(LineItem)
                   .and have_attributes(quantity: 1, name: 'book', price: 12.49, imported: true)
      end
    end

    context 'when line is missing a price' do
      let(:input_line) { '1 book at' }

      it 'raises an ArgumentError with specific message' do
        expect { subject }.to raise_error(ArgumentError, /Missing or invalid price/)
      end
    end

    context 'when line is missing a quantity' do
      let(:input_line) { 'book at 12.49' }

      it 'raises an ArgumentError with specific message' do
        expect { subject }.to raise_error(ArgumentError, /Missing or invalid quantity/)
      end
    end

    context 'when line is missing at separator' do
      let(:input_line) { '1 book 12.49' }

      it 'raises an ArgumentError with specific message' do
        expect { subject }.to raise_error(ArgumentError, /Missing 'at' separator/)
      end
    end
  end

  describe '#tax_exempt?' do
    context 'when item is a book' do
      let(:name) { 'book' }

      it 'returns true' do
        expect(ClassifyItem).to receive(:call).with(name: 'book')
        expect(line_item.tax_exempt?).to be(true)
      end
    end
  end

  describe '#tax_amount' do
    context 'when item is exempt from basic sales tax' do
      before { allow(line_item).to receive(:tax_exempt?).and_return(true) }

      context 'when the item is not imported' do
        let(:imported) { false }
        it 'returns 0' do
          expect(line_item.tax_amount).to eq(0)
        end
      end

      context 'when the item is imported' do
        let(:imported) { true }

        it 'returns import tax only' do
          expect(line_item.tax_amount).to eq(0.5)
        end
      end
    end

    context 'when item is not exempt from basic sales tax' do
      before { allow(line_item).to receive(:tax_exempt?).and_return(false) }

      context 'when the item is not imported' do
        it 'returns basic sales tax only' do
          expect(line_item.tax_amount).to eq(1.0)
        end
      end

      context 'when the item is imported' do
        let(:imported) { true }

        it 'returns combined basic and import tax' do
          expect(line_item.tax_amount).to eq(1.5)
        end
      end
    end
  end

  describe '#total_price' do
    context 'for a regular item' do
      let(:imported) { false }

      before { allow(line_item).to receive(:tax_exempt?).and_return(true) }

      it 'includes the tax in the total' do
        expect(line_item.total_price).to eq(10.0)
      end
    end

    context 'for an imported item' do
      let(:imported) { true }

      before { allow(line_item).to receive(:tax_exempt?).and_return(false) }

      it 'includes both basic and import tax' do
        expect(line_item.total_price).to eq(11.5)
      end
    end
  end

  describe '#receipt_line' do
    context 'for a regular item' do
      let(:name) { 'book' }
      let(:imported) { false }

      it 'formats correctly without imported prefix' do
        expect(line_item.receipt_line).to eq('1 book: 10.00')
      end
    end

    context 'for an imported item' do
      let(:name) { 'bottle of perfume' }
      let(:imported) { true }

      it 'formats correctly with imported prefix' do
        expect(line_item.receipt_line).to eq('1 imported bottle of perfume: 11.50')
      end
    end
  end

  describe '#round_up_tax_amount' do
    let(:price) { 17.87 }
    let(:imported) { true }

    before { allow(line_item).to receive(:tax_exempt?).and_return(false) }

    it 'rounds up to the nearest 0.05' do
      expect(line_item.tax_amount).to eq(2.70)
    end
  end
end
