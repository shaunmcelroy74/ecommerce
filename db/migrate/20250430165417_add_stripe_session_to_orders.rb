class AddStripeSessionToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :stripe_session_id, :string
  end
end
