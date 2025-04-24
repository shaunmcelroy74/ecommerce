class CartItemsController < ApplicationController
  def create
    current_cart.add_product(params[:product_id])
    redirect_to cart_path, notice: "Added to cart!"
  end

  def update
    item = current_cart.cart_items.find(params[:id])
    item.update!(quantity: params[:quantity])
    redirect_to cart_path, notice: "Cart updated."
  end

  def destroy
    current_cart.cart_items.find(params[:id]).destroy
    redirect_to cart_path, notice: "Removed from cart."
  end
end
