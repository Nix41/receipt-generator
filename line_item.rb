# frozen_string_literal: true

require_relative 'classify_item'
require 'bigdecimal'

# Represents a shopping item with its quantity, price, and tax information
# Handles parsing from input strings and calculating applicable taxes
class LineItem
  BASIC_TAX_RATE = BigDecimal('0.10')
  IMPORT_TAX_RATE = BigDecimal('0.05')
  TAX_ROUNDING_FACTOR = BigDecimal('20.0')
  ITEM_REGEX = /^(\d+)\s+(imported\s+)?(.+?)\s+at\s+([\d.]+)$/.freeze

  attr_reader :quantity, :imported, :name, :price

  def initialize(quantity:, name:, price:, imported: false)
    @quantity = quantity
    @imported = imported
    @name = name
    @price = price
  end

  def self.parse(line)
    match = ITEM_REGEX.match(line.strip)
    raise ArgumentError, validate_error_message(line) unless match

    quantity = match[1].to_i
    imported = !match[2].nil?
    name = match[3].strip
    price = match[4].to_r

    new(quantity: quantity, imported: imported, name: name, price: price)
  end

  def self.validate_error_message(line)
    return "Invalid input: #{line} (Missing or invalid quantity at start)" unless line =~ /^\d+/
    return "Invalid input: #{line} (Missing 'at' separator)" unless line =~ / at/
    return "Invalid input: #{line} (Missing or invalid price at end)" unless line =~ / at [\d.]+$/

    "Invalid input: #{line}"
  end

  def tax_exempt?
    ClassifyItem.call(name: @name) != 'other'
  end

  def tax_amount
    base_tax = tax_exempt? ? 0 : BASIC_TAX_RATE
    import_tax = @imported ? IMPORT_TAX_RATE : 0
    total_tax_rate = base_tax + import_tax
    tax_per_item = round_up_tax_amount(total_tax_rate * @price)
    tax_per_item * @quantity
  end

  def total_price
    @price * @quantity + tax_amount
  end

  def receipt_line
    "#{@quantity} #{@imported ? 'imported ' : ''}#{@name}: #{format('%.2f', total_price)}"
  end

  private

  def round_up_tax_amount(amount)
    (amount * TAX_ROUNDING_FACTOR).ceil / TAX_ROUNDING_FACTOR
  end
end
