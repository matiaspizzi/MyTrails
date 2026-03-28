FactoryBot.define do
  factory :objective do
    association :employee, factory: :user
    sequence(:title) { |n| "Objective #{n}" }
    description { "A detailed description of the objective." }
    estimated_completion_at { 30.days.from_now }
    status { :New }

    trait :in_progress do
      status { :In_Progress }
    end

    trait :in_review do
      status { :In_Review }
    end

    trait :done do
      status { :Done }
      rating { 4 }
      association :rater, factory: :user, role: "leader"
    end
  end
end
