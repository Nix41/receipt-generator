# frozen_string_literal: true

require 'informers'

# Singleton object to classifying a line item
class ClassifyItem
  PRODUCT_CATEGORIES = %w[book food medical-product other].freeze

  def initialize
    @classifier = Informers.pipeline('zero-shot-classification', 'Xenova/distilbert-base-uncased-mnli')
  end

  def call(name:)
    result = @classifier.call(name, PRODUCT_CATEGORIES)
    result[:labels][0]
  end

  def self.instance
    @instance ||= new
  end

  def self.call(name:)
    instance.call(name: name)
  end
end
