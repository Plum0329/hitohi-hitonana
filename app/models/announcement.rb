# frozen_string_literal: true

class Announcement < ApplicationRecord
  belongs_to :admin, class_name: 'User'

  has_many :announcement_reads, dependent: :destroy
  has_many :readers, through: :announcement_reads, source: :user

  validates :title, presence: true
  validates :content, presence: true

  enum :status, { draft: 0, published: 1, archived: 2 }
  enum :priority, { normal: 0, important: 1, urgent: 2 }

  scope :active, -> { where(status: :published) }
  scope :recent, -> { order(created_at: :desc) }
end
