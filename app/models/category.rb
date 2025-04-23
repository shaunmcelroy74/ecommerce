class Category < ApplicationRecord
  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_fill: [ 50, 50 ]
  end

  has_many :products

  validates :name, presence: true, uniqueness: true

  # Validate the attached image (e.g., maximum size and allowed content types)
  validate :acceptable_image

  private

  def acceptable_image
    return unless image.attached?

    # Limit file size to 2MB
    if image.byte_size > 5.megabytes
      errors.add(:image, "is too big (should be less than 5MB)")
    end

    # Validate content type
    acceptable_types = [ "image/jpeg", "image/png" ]
    unless acceptable_types.include?(image.content_type)
      errors.add(:image, "must be a JPEG or PNG")
    end
  end
end
