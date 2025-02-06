class PostsDeletionRequest < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :reason, presence: true, length: { minimum: 10, maximum: 1000 }
  enum status: { pending: 0, approved: 1, rejected: 2 }

  validate :no_duplicate_requests, on: :create

  private

  def no_duplicate_requests
    if PostsDeletionRequest.exists?(post_id: post_id, status: :pending)
      errors.add(:base, '既にこの投稿の削除申請が提出されています')
    end
  end
end