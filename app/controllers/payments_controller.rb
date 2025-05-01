# app/controllers/payments_controller.rb
class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def create
    order        = current_user.orders.find(params[:order_id])
    success_base = success_payments_url(order_id: order.id)

    # 1) Build the product lines
    items = order.order_products.map do |line|
      {
        price_data: {
          currency:     "cad",
          product_data: { name: line.product_name },
          unit_amount:  line.unit_price_cents
        },
        quantity: line.quantity
      }
    end

    # 2) Append a "Taxes" line if there is any tax
    tax_cents = order.gst_cents + order.pst_cents + order.hst_cents
    if tax_cents.positive?
      items << {
        price_data: {
          currency:     "cad",
          product_data: { name: "Taxes" },
          unit_amount:  tax_cents
        },
        quantity: 1
      }
    end

    # 3) Create the Stripe session using our augmented items
    stripe_session = Stripe::Checkout::Session.create(
      payment_method_types: [ "card" ],
      line_items:           items,
      mode:                 "payment",
      success_url:          "#{success_base}&session_id={CHECKOUT_SESSION_ID}",
      cancel_url:           cancel_payments_url(order_id: order.id)
    )

    order.update!(stripe_session_id: stripe_session.id)
    redirect_to stripe_session.url, allow_other_host: true
  end

  def success
    @order         = current_user.orders.find(params[:order_id])
    stripe_session = Stripe::Checkout::Session.retrieve(params[:session_id])

    if stripe_session.payment_status == "paid"
      @order.update!(
        paid:              true,
        stripe_payment_id: stripe_session.payment_intent
      )
      flash.now[:notice] = "Payment received—thank you!"
      render :success
    else
      redirect_to cancel_payments_path(order_id: @order.id),
                  alert: "Payment not completed."
    end
  end

  def cancel
    @order = current_user.orders.find(params[:order_id])
    flash.now[:alert] = "Payment canceled—feel free to try again."
    render :cancel
  end
end
