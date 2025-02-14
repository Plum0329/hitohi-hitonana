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

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, uniqueness: true, presence: true
  validates :name, presence: true

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
end
