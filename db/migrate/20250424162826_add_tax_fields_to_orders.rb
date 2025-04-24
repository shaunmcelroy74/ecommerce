class AddTaxFieldsToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :gst_cents, :integer
    add_column :orders, :pst_cents, :integer
    add_column :orders, :hst_cents, :integer

    # override the plain decimal to specify precision & scale
    add_column :orders, :gst_rate, :decimal, precision: 5, scale: 4
    add_column :orders, :pst_rate, :decimal, precision: 5, scale: 4
    add_column :orders, :hst_rate, :decimal, precision: 5, scale: 4
  end
end
