# frozen_string_literal: true

FactoryBot.define do
  factory :direct_message_read do
    direct_message
    user
  end
end
