class CheckoutsController < ApplicationController
  before_action :authenticate_user!

  def new
    @cart = current_cart
    redirect_to cart_path, alert: "Your cart is empty" if @cart.empty?
    # Render the “confirm address & order summary” form in new.html.erb
  end

  def create
    @cart = current_cart
    return redirect_to cart_path, alert: "Your cart is empty" if @cart.empty?

    ActiveRecord::Base.transaction do
      # 1) Save address if missing
      current_user.update!(user_params) if params[:user]

      # 2) Build order header
      @order = current_user.orders.build(
        street:      current_user.street,
        city:        current_user.city,
        postal_code: current_user.postal_code,
        province:    current_user.province
      )

      subtotal  = 0
      total_tax = 0

      # 3) For each cart item, snapshot product and tax
      @cart.items.each do |item|
        product = item.product
        qty     = item.quantity
        price   = product.price_cents

        tax_data = TaxCalculator.calculate(price, current_user.province.code)
        line_tax = tax_data[:tax_cents] * qty

        @order.order_products.build(
          product:           product,
          unit_price_cents:  price,
          product_name:      product.name,
          quantity:          qty,
          tax_cents:         line_tax,
          tax_rate:          tax_data[:rate]
        )

        subtotal  += price * qty
        total_tax += line_tax
      end

      # 4) Total up and save
      @order.subtotal_cents    = subtotal
      @order.total_tax_cents   = total_tax
      @order.grand_total_cents = subtotal + total_tax
      @order.save!

      # 5) Clear the cart
      session[:cart_id] = nil

      redirect_to checkout_path(@order)
    end
  end

  def show
    @order = Order.find(params[:id])
    # display the final invoice here
  end

  private

  def user_params
    params.require(:user).permit(:street, :city, :province_id, :postal_code)
  end
end
