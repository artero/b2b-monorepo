FactoryBot.define do
  factory :admin_user do
    sequence(:email) { |n| "admin#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }

    trait :second_admin do
      # Uses the sequence by default
    end

    trait :super_admin do
      super_admin { true }
    end

    trait :login_test do
      # Uses the sequence by default
    end
  end
end
