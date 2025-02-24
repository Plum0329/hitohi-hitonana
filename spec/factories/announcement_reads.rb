# frozen_string_literal: true

FactoryBot.define do
  factory :announcement_read do
    announcement
    user
  end
end
