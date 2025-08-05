# frozen_string_literal: true

require_relative '../classify_item'

RSpec.describe ClassifyItem do
  subject { ClassifyItem.call(name: name) }

  let(:name) { 'book of the damned' }

  describe '.instance' do
    it 'returns a singleton instance' do
      expect(ClassifyItem.instance).to eq(ClassifyItem.instance)
      expect(ClassifyItem.instance).to be_a(ClassifyItem)
    end
  end

  describe '#call' do
    context 'when name is a book' do
      it 'returns book' do
        is_expected.to eq('book')
      end
    end

    context 'when name is a food' do
      let(:name) { 'boxes of chocolates' }

      it 'returns food' do
        is_expected.to eq('food')
      end
    end

    context 'when name is a medical product' do
      let(:name) { 'headache pills' }

      it 'returns medical product' do
        is_expected.to eq('medical-product')
      end
    end

    context 'when name is other' do
      let(:name) { 'perfume' }

      it 'returns other' do
        is_expected.to eq('other')
      end
    end
  end
end
