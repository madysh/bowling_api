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

    trait :with_frames do
      after(:create) do |game|
        create_list(:frame, rand(1..Game::MAX_FRAMES-2), :with_shots)
      end
    end
  end
end
