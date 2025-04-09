class Product < ApplicationRecord
  has_many_attached :images do |attachable|
  attachable.variant :thumb, resize_to_fill: [ 50, 50 ]
  attachable.variant :medium, resize_to_fill: [ 250, 250 ]
end


  belongs_to :category
  has_many :order_products
end
