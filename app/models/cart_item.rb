class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  def line_total
    (product.price_cents * quantity) / 100.0
  end
end
