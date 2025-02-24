# frozen_string_literal: true

FactoryBot.define do
  factory :announcement do
    sequence(:title) { |n| "お知らせタイトル#{n}" }
    content { 'お知らせ本文です。' }
    status { :published }
    priority { :normal }
    published_at { Time.current }
    admin factory: %i[user], role: :admin
  end
end
