FactoryBot.define do
  factory :business_partner do
    sequence(:name) { |n| "Business Partner #{n}" }
    sequence(:ln_id) { |n| "code_#{n}" }
    sequence(:email) { |n| "partner#{n}@example.com" }
  end
end
