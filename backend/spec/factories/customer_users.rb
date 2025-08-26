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

    trait :with_empty_name do
      name { "" }
      surname { "Johnson" }
      generated_password_at { 1.week.ago }
    end

    trait :with_empty_surname do
      name { "Bob" }
      surname { "" }
      generated_password_at { nil }
    end

    trait :with_whitespace do
      name { " Alice " }
      surname { " Brown " }
      generated_password_at { nil }
    end

    trait :recently_generated_password do
      generated_password_at { 1.hour.ago }
    end
  end
end
