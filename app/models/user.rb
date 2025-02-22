# frozen_string_literal: true

class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :posts
  has_many :themes
  has_many :likes, dependent: :destroy
  has_many :visible_posts, -> { available }, class_name: 'Post'
  has_many :visible_themes, -> { available }, class_name: 'Theme'
  has_many :liked_posts, through: :likes, source: :likeable, source_type: 'Post'
  has_many :liked_themes, through: :likes, source: :likeable, source_type: 'Theme'
  has_many :posts_deletion_requests
  has_many :themes_deletion_requests
  has_many :posts_reports
  has_many :themes_reports

  validates :password,
            length: { minimum: 8 },
            format: {
              with: /\A(?=.*?[a-zA-Z])(?=.*?\d)[a-zA-Z\d]+\z/,
              message: 'は半角英字と数字をそれぞれ1文字以上含む必要があります'
            },
            if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, uniqueness: true, presence: true
  validates :name, presence: true

  before_create :generate_confirmation_token

  enum :role, { general: 0, admin: 1 }

  def likes?(likeable)
    likes.exists?(likeable: likeable)
  end

  def inactive?
    deleted_at.present?
  end

  alias deleted? inactive?

  def deactivate
    update(deleted_at: Time.current)
  end

  def activate
    update(deleted_at: nil)
  end

  def active_for_authentication?
    !inactive?
  end

  def confirm_email
    self.email_confirmed = true
    self.confirmation_token = nil
    save
  end

  def can_post_general?
    return true if last_general_post_at.nil?

    last_general_post_at.in_time_zone('Asia/Tokyo').to_date < Date.current.in_time_zone('Asia/Tokyo').to_date
  end

  private

  def generate_confirmation_token
    self.confirmation_token = SecureRandom.urlsafe_base64
    self.confirmation_sent_at = Time.current
  end
end
