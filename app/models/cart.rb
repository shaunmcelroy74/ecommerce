class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy

  # convenience: total number of items in the cart
  def total_items
    cart_items.sum(:quantity)
  end
end
