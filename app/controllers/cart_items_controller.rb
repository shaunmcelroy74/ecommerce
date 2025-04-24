# app/controllers/cart_items_controller.rb
class CartItemsController < ApplicationController
  # POST /cart_items
  def create
    @item = current_cart.cart_items.find_or_initialize_by(product_id: params[:product_id])
    @item.quantity = (@item.quantity || 0) + 1
    @item.save!
    redirect_to cart_path, notice: "Added to cart!"
  end

  # PATCH/PUT /cart_items/:id
  def update
    @item = current_cart.cart_items.find(params[:id])
    if @item.update(cart_item_params)
      redirect_to cart_path, notice: "Quantity updated."
    else
      redirect_to cart_path, alert: "Could not update quantity."
    end
  end

  # DELETE /cart_items/:id
  def destroy
    current_cart.cart_items.find(params[:id]).destroy
    redirect_to cart_path, notice: "Removed from cart."
  end

  private

  # Only allow the quantity through
  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end
end
