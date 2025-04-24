# app/models/cart.rb
class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy

  # Adds one of the given product to this cart, or bumps the quantity if it's already in there
  def add_product(product_id)
    item = cart_items.find_or_initialize_by(product_id: product_id)
    item.quantity = (item.quantity || 0) + 1
    item.save!
    item
  end

  # total number of items (sum of quantities)
  def total_items
    cart_items.sum(:quantity)
  end

  # is the cart empty?
  def empty?
    cart_items.none?
  end

  # convenience for listing items along with their products
  def items
    cart_items.includes(:product)
  end

  # total price in cents
  def subtotal_cents
    items.inject(0) { |sum, item| sum + item.quantity * item.product.price }
  end
end
