class PaymentsController < ApplicationController
  before_action :authenticate_user!

  def create
    order = current_user.orders.find(params[:order_id] || params[:id])
    session = Stripe::Checkout::Session.create(
      payment_method_types: [ "card" ],
      line_items: order.order_products.map do |op|
        {
          price_data: {
            currency: "cad",
            unit_amount: op.unit_price_cents,
            product_data: { name: op.product_name }
          },
          quantity: op.quantity
        }
      end,
      mode: "payment",
      success_url: payments_success_url + "?order_id=#{order.id}&session_id={CHECKOUT_SESSION_ID}",
      cancel_url:  payments_cancel_url + "?order_id=#{order.id}"
    )

    redirect_to session.url, allow_other_host: true
  end

  def success
    order = current_user.orders.find(params[:order_id])
    stripe_session = Stripe::Checkout::Session.retrieve(params[:session_id])

    if stripe_session.payment_status == "paid"
      order.update!(paid: true, stripe_payment_id: stripe_session.payment_intent)
      redirect_to checkout_path(order), notice: "Payment received—thank you!"
    else
      redirect_to payments_cancel_path(order_id: order.id), alert: "Payment not completed."
    end
  end

  def cancel
    order = current_user.orders.find(params[:order_id])
    redirect_to checkout_path(order), alert: "Payment canceled. You can try again."
  end
end
