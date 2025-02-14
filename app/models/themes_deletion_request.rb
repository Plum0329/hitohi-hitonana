# frozen_string_literal: true

class ThemesDeletionRequest < ApplicationRecord
  belongs_to :user
  belongs_to :theme

  validates :reason, presence: true, length: { minimum: 10, maximum: 1000 }
  enum :status, { pending: 0, approved: 1, rejected: 2 }

  validate :no_duplicate_requests, on: :create

  def execute_deletion!
    return false unless pending?

    ActiveRecord::Base.transaction do
      theme.posts.update_all(theme_id: nil)

      if theme.soft_delete
        update!(status: :approved)
        true
      else
        raise ActiveRecord::Rollback
        false
      end
    end
  rescue StandardError => e
    Rails.logger.error "Theme deletion failed: #{e.message}"
    false
  end

  private

  def no_duplicate_requests
    return unless ThemesDeletionRequest.exists?(theme_id: theme_id, status: :pending)

    errors.add(:base, '既にこのお題の削除申請が提出されています')
  end
end
