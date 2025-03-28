# frozen_string_literal: true

class DirectMessage < ApplicationRecord
  belongs_to :admin, class_name: 'User'
  belongs_to :recipient, class_name: 'User'
  belongs_to :parent, class_name: 'DirectMessage', optional: true

  has_many :direct_message_reads, dependent: :destroy
  has_many :readers, through: :direct_message_reads, source: :user
  has_many :replies, class_name: 'DirectMessage', foreign_key: 'parent_id', dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true

  after_create :reset_read_status, if: :reply?

  enum :status, { draft: 0, published: 1, archived: 2 }
  enum :priority, { normal: 0, important: 1, urgent: 2 }

  scope :active, -> { where(status: :published) }
  scope :recent, -> { order(created_at: :desc) }
  scope :roots, -> { where(parent_id: nil) }
  scope :replies, -> { where.not(parent_id: nil) }

  def replyable?
    published? && allow_reply
  end

  def root?
    parent_id.nil?
  end

  def reply?
    parent_id.present?
  end

  private

  def reset_read_status
    target_message = parent
    return unless target_message.present? && admin.admin?

    DirectMessageRead.where(direct_message: target_message)
                     .where(user: recipient)
                     .delete_all
  end
end
