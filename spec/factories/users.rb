FactoryBot.define do
  factory :user do
    sequence(:email_address) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    name { "John" }
    surname { "Doe" }
    role { "employee" }
    confirmed_at { Time.current }

    trait :leader do
      role { "leader" }
    end

    trait :admin do
      role { "admin" }
    end

    trait :unconfirmed do
      confirmed_at { nil }
    end
  end
end
