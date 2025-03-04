# frozen_string_literal: true

class Contact < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: { message: 'を入力してください' }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'の形式が正しくありません' },
                    length: { maximum: 255 },
                    if: -> { email.present? }
  validates :content, presence: true, length: { maximum: 2000 }
  validates :category, presence: true
  validates :privacy_policy_agreed, acceptance: true

  enum :status, {
    pending: 'pending',
    in_progress: 'in_progress',
    completed: 'completed'
  }, default: 'pending'

  enum :category, {
    general: 'general',
    bug_report: 'bug_report',
    feature_request: 'feature_request',
    other: 'other'
  }, default: 'general'

  scope :recent, -> { order(created_at: :desc) }
  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :by_category, ->(category) { where(category: category) if category.present? }

  def reply(content)
    return false if content.blank?

    update(
      reply_content: content,
      replied_at: Time.current,
      status: :completed
    )
  end

  def replied?
    replied_at.present?
  end
end
