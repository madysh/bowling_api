FactoryBot.define do
  factory :shot do
    frame
    pins { rand(0..Shot::MAX_PINS) }

    trait :completed do
      completed { true }
    end
  end
end
