class Category < ApplicationRecord
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_fill: [ 50, 50 ]
  end

  has_many :products
end
