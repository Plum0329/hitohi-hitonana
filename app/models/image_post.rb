class ImagePost < ApplicationRecord
  has_many :posts
  has_many :themes, dependent: :destroy
  has_one_attached :image

  validates :description, presence: true
end