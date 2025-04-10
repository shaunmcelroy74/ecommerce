class Order < ApplicationRecord
  has_many :order_products, dependent: :destroy

  validates :name,    presence: true
  validates :address, presence: true

  validates :cart_data, presence: true
  validate  :cart_data_must_be_valid_json

  validate :must_have_at_least_one_product

  private

  def cart_data_must_be_valid_json
    JSON.parse(cart_data)
  rescue JSON::ParserError
    errors.add(:cart_data, "must be valid JSON")
  end

  def must_have_at_least_one_product
    if order_products.empty?
      errors.add(:base, "Must have at least one product")
    end
  end
end
