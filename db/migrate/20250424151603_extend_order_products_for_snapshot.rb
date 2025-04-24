class ExtendOrderProductsForSnapshot < ActiveRecord::Migration[8.0]
  def change
    add_column :order_products, :unit_price_cents, :integer
    add_column :order_products, :product_name,      :string
    add_column :order_products, :tax_cents,         :integer
    add_column :order_products, :tax_rate,          :decimal, precision: 5, scale: 4
  end
end
