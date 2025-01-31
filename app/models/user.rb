class User < ApplicationRecord
  authenticates_with_sorcery!
  has_many :posts
  has_many :themes
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :likeable, source_type: 'Post'
  has_many :liked_themes, through: :likes, source: :likeable, source_type: 'Theme'

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, uniqueness: true, presence: true
  validates :name, presence: true

  enum role: { general: 0, admin: 1 }

  def likes?(likeable)
    likes.exists?(likeable: likeable)
  end

  def soft_delete
    update(deleted_at: Time.current)
  end

  def deleted?
    deleted_at.present?
  end
end