FactoryBot.define do
  factory :customer_user do
    sequence(:name) { |n| "User#{n}" }
    sequence(:surname) { |n| "Surname#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:phone_number) { |n| "+123456789#{n}" }
    password { "password123" }
    password_confirmation { "password123" }
    association :customer
    blocked { false }
    generated_password_at { 2.days.ago }
    provider { "email" }
    uid { email }

    trait :blocked do
      blocked { true }
      generated_password_at { nil }
    end

    trait :recently_generated_password do
      generated_password_at { 1.hour.ago }
    end
  end
end
