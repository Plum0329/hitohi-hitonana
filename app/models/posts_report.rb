class PostsReport < ApplicationRecord
  include Reportable
  belongs_to :user
  belongs_to :post

  validate :cannot_report_own_post, on: :create
  validate :no_duplicate_reports, on: :create

  private

  def cannot_report_own_post
    if user_id == post.user_id
      errors.add(:base, '自分の投稿は報告できません')
    end
  end

  def no_duplicate_reports
    if PostsReport.exists?(post_id: post_id, user_id: user_id, status: :pending)
      errors.add(:base, 'すでにこの投稿を報告しています')
    end
  end
end