FactoryBot.define do
  factory :customer do
    sequence(:name) { |n| "Customer #{n}" }
    sequence(:code) { |n| "code_#{n}" }
    sequence(:email) { |n| "customer#{n}@example.com" }

    trait :foo do
      name { "Foo" }
      code { "foo_code" }
      email { "hello@foo.com" }
    end

    trait :bar do
      name { "Bar" }
      code { "bar_code" }
      email { "hello@bar.com" }
    end
  end
end
