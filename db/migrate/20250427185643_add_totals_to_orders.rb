class AddTotalsToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :subtotal_cents, :integer
    add_column :orders, :total_tax_cents, :integer
    add_column :orders, :grand_total_cents, :integer
  end
end
