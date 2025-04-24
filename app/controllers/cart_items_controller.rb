class CartItemsController < ApplicationController
  def create
    # build or increment
    item = current_cart.cart_items.find_or_initialize_by(product_id: params[:product_id])
    item.quantity += 1
    item.save!
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
