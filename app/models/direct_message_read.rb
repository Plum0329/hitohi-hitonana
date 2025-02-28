# frozen_string_literal: true

class DirectMessageRead < ApplicationRecord
  belongs_to :direct_message
  belongs_to :user

  validates :user_id, uniqueness: { scope: :direct_message_id }
end
