class ExtendOrdersForCheckout < ActiveRecord::Migration[8.0]
  def change
    add_reference :orders, :user, null: true, foreign_key: true
    add_column    :orders, :street,       :string
    add_column    :orders, :city,         :string
    add_column    :orders, :postal_code,  :string
    add_reference :orders, :province,     null: true, foreign_key: true
  end
end
