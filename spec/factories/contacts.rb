# frozen_string_literal: true

FactoryBot.define do
  factory :contact do
    sequence(:name) { |n| "User#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    category { "general" }
    sequence(:content) { |n| "これはテストのお問い合わせ内容#{n}です。" }
    privacy_policy_agreed { true }
    status { "pending" }
  end
end