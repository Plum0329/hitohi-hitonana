# frozen_string_literal: true

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true, counter_cache: true

  validates :user_id, uniqueness: { scope: %i[likeable_type likeable_id] }
  validate :cannot_like_own_content

  private

  def cannot_like_own_content
    return unless user_id == likeable.user_id

    errors.add(:base, '自分の投稿にはいいねできません')
  end
end
