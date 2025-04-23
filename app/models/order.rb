# app/models/order.rb
class Order < ApplicationRecord
  # Associations
  belongs_to :user,     optional: true
  belongs_to :province, optional: true

  has_many :order_products, dependent: :destroy

  # Validations
  validates :address, presence: true
  validate  :cart_data_must_be_valid_json
  validate  :must_have_at_least_one_product

  # Helper methods to convert stored cents → dollars
  def subtotal
    subtotal_cents.to_f / 100
  end

  def total_tax
    total_tax_cents.to_f / 100
  end

  def grand_total
    grand_total_cents.to_f / 100
  end

  private

  # Ensure the cart_data column (if you’re using it) contains valid JSON
  def cart_data_must_be_valid_json
    JSON.parse(cart_data)
  rescue JSON::ParserError
    errors.add(:cart_data, "must be valid JSON")
  end

  # Make sure there is at least one associated line item
  def must_have_at_least_one_product
    if order_products.empty?
      errors.add(:base, "Must have at least one product")
    end
  end
end
