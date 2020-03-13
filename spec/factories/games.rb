FactoryBot.define do
  factory :game do
    completed { [true, false].sample }

    trait :completed do
      completed { true }
    end
  end
end
