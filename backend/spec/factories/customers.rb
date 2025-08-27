FactoryBot.define do
  factory :customer do
    sequence(:name) { |n| "Customer #{n}" }
    sequence(:code) { |n| "code_#{n}" }
    sequence(:email) { |n| "customer#{n}@example.com" }
  end
end
