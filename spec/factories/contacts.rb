# frozen_string_literal: true

FactoryBot.define do
  factory :contact do
    name { |n| "user#{n}@example.com" }
    email { |n| "User #{n}" }
    category { 'service' }
    privacy_policy_agreed { true }
  end
end
