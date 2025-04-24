class CheckoutsController < ApplicationController
  before_action :authenticate_user!

  def new
    @cart = current_cart
    redirect_to cart_path and return if @cart.empty?

    @user = current_user
    @address_missing = @user.street.blank? || @user.province_id.blank?
  end
end
