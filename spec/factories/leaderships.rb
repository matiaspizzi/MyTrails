FactoryBot.define do
  factory :leadership do
    association :leader, factory: :user, role: "leader"
    association :employee, factory: :user
  end
end
