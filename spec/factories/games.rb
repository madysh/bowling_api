FactoryBot.define do
  factory :game do
    completed { [true, false].sample }
    score { rand(0..300) }

    trait :completed do
      completed { true }
    end

    trait :not_completed do
      completed { false }
    end
  end
end
