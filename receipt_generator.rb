# frozen_string_literal: true

require_relative 'line_item'

# Processes sales tax calculations for shopping items and generates receipts.
# Delegates item-specific logic to LineItem class.
# Handles aggregation and receipt formatting.
class ReceiptGenerator
  def initialize(input_lines:)
    @tax = 0
    @total_price = 0
    @receipt_items = []
    @input_lines = input_lines
    @line_items = []
  end

  def call
    process_shopping_list
    receipt
  end

  def process_shopping_list
    @input_lines.each do |line|
      next if line.strip.empty?

      begin
        item = LineItem.parse(line)
        @line_items << item
        process_line_item(item)
      end
    end
  end

  def receipt
    <<~RECEIPT
      #{@receipt_items.join("\n")}
      Sales Taxes: #{format('%.2f', @tax)}
      Total: #{format('%.2f', @total_price)}
    RECEIPT
  end

  private

  def process_line_item(item)
    @tax += item.tax_amount
    @total_price += item.total_price
    @receipt_items << item.receipt_line
  end
end
