# app/controllers/checkouts_controller.rb
class CheckoutsController < ApplicationController
  before_action :authenticate_user!

  def new
    @cart = current_cart
    redirect_to cart_path, alert: "Your cart is empty" if @cart.empty?
    # renders app/views/checkouts/new.html.erb
  end

  def create
    @cart = current_cart
    return redirect_to cart_path, alert: "Your cart is empty" if @cart.empty?

    ActiveRecord::Base.transaction do
      # 1) Save address if user submitted it
      current_user.update!(user_params) if params[:user]

      # 2) Build the Order header with shipping info
      @order = current_user.orders.build(
        street:      current_user.street,
        city:        current_user.city,
        postal_code: current_user.postal_code,
        province:    current_user.province
      )

      subtotal  = 0
      total_tax = 0

      # 3) Snapshot each cart item + per‐item tax
      @cart.items.each do |item|
        product = item.product
        qty     = item.quantity
        price   = product.price

        # tax_data is a hash with :gst, :pst, :hst rates
        tax_data = TaxCalculator.new(price * qty, current_user.province.code).rates
        line_tax = (price * qty * tax_data[:gst] +
                    price * qty * tax_data[:pst] +
                    price * qty * tax_data[:hst]).round

        @order.order_products.build(
          product:          product,
          unit_price_cents: price,
          product_name:     product.name,
          quantity:         qty,
          tax_cents:        line_tax,
          tax_rate:         tax_data.values.sum
        )

        subtotal  += price * qty
        total_tax += line_tax
      end

      # 4) Order‐level totals
      calc = TaxCalculator.new(subtotal, current_user.province.code)
      @order.assign_attributes(
        subtotal_cents:    subtotal,
        total_tax_cents:   calc.gst_cents + calc.pst_cents + calc.hst_cents,
        grand_total_cents: subtotal + calc.gst_cents + calc.pst_cents + calc.hst_cents,
        gst_cents:         calc.gst_cents,
        pst_cents:         calc.pst_cents,
        hst_cents:         calc.hst_cents,
        gst_rate:          calc.rates[:gst],
        pst_rate:          calc.rates[:pst],
        hst_rate:          calc.rates[:hst]
      )

      @order.save!

      # 5) Empty the cart
      session[:cart_id] = nil

      redirect_to checkout_path(@order)
    end
  end

  def show
    @order = Order.find(params[:id])

    # If Stripe has redirected back with `?paid=true`, confirm payment and mark paid
    if params[:paid] == "true" && @order.stripe_session_id.present?
      session_data = Stripe::Checkout::Session.retrieve(@order.stripe_session_id)
      if session_data.payment_status == "paid"
        @order.update!(paid: true, stripe_payment_id: session_data.payment_intent)
      end
    end

    # renders app/views/checkouts/show.html.erb (your invoice)
  end

  private

  def user_params
    params.require(:user).permit(:street, :city, :province_id, :postal_code)
  end
end
