class Product < ApplicationRecord
  has_many_attached :images do |attachable|
    attachable.variant :thumb,  resize_to_fill: [ 50, 50 ]
    attachable.variant :medium, resize_to_fill: [ 250, 250 ]
  end

  belongs_to :category
  has_many :order_products, dependent: :destroy

  validates :name,        presence: true, uniqueness: true
  validates :price,       presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :description, presence: true, length: { minimum: 10 }
  validates :category,    presence: true

  validate :acceptable_images

  private

  def acceptable_images
    return unless images.attached?

    images.each do |image|
      unless image.content_type.starts_with?("image/")
        errors.add(:images, "must be an image")
      end

      if image.byte_size > 5.megabytes
        errors.add(:images, "is too big (should be less than 5MB)")
      end
    end
  end
end
