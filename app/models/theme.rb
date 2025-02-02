class Theme < ApplicationRecord
  belongs_to :user
  belongs_to :image_post, optional: true
  has_many :posts, dependent: :nullify
  has_one_attached :image
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :users_who_liked, through: :likes, source: :user

  validates :description, presence: { message: "お題を入力してください" }
  validates :status, presence: { message: "ステータスを選択してください" }

  validate :validate_image_type, if: -> { image.attached? }

  scope :recent, -> { order(created_at: :desc) }
  scope :available, -> { where(deleted_at: nil) }
  scope :deleted, -> { where.not(deleted_at: nil) }

  enum status: {
    draft: 0,
    published: 1,
    closed: 2
  }

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

  def status
    'published'
  end

  def soft_delete
    update!(deleted_at: Time.current)
  rescue => e
    Rails.logger.error "Soft delete failed: #{e.message}"
    false
  end

  def restore
    update!(deleted_at: nil)
  rescue => e
    Rails.logger.error "Restore failed: #{e.message}"
    false
  end

  private

  def validate_image_type
    if !image.content_type.in?(%w[image/jpeg image/jpg image/png])
      errors.add(:image, 'はJPEG、JPG、PNG形式のみ許可されています')
    end
  end
end