class ImagePost < ApplicationRecord
  has_one_attached :image
  has_one :theme
  has_many :posts, dependent: :nullify
  
  validates :description, length: { maximum: 10 }
  
  validates :image,
    content_type: { 
      in: ['image/png', 'image/jpg', 'image/jpeg'], 
      message: 'はPNG、JPEG、JPG形式のみ対応しています'
    },
    size: { 
      less_than: 5.megabytes, 
      message: 'は5MB以下にしてください'
    },
    allow_nil: true

  def display_image
    if image.attached?
      image.variant(resize_to_limit: [400, 300])
    end
  end

  def small_image
    if image.attached?
      image.variant(resize_to_limit: [200, 150])
    end
  end
end