# frozen_string_literal: true

FactoryBot.define do
  factory :direct_message do
    title { 'テストメッセージ' }
    content { 'これはテストメッセージです。' }
    status { :published }
    priority { :normal }
    published_at { Time.current }
    admin factory: %i[user], role: :admin
    recipient factory: %i[user], role: :general

    trait :draft do
      status { :draft }
      published_at { nil }
    end

    trait :archived do
      status { :archived }
    end

    trait :important do
      priority { :important }
    end

    trait :urgent do
      priority { :urgent }
    end
  end
end
