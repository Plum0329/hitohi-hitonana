class Theme < ApplicationRecord
  belongs_to :user
  belongs_to :image_post, optional: true, dependent: :destroy
  has_many :posts, dependent: :nullify
  has_one_attached :image
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :users_who_liked, through: :likes, source: :user

  validates :description, presence: true

  def posted_by?(user)
    posts.exists?(user_id: user.id)
  end

  def available_for?(user)
    return false if user.nil?
    return false if user.id == self.user_id
    return false if posted_by?(user)
    true
  end

  def display_image
    return nil unless image.attached?
    image.variant(resize_to_limit: [400, 300])
  end

  def small_image
    return nil unless image.attached?
    image.variant(resize_to_limit: [200, 150])
  end
end