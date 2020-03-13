FactoryBot.define do
  factory :frame do
    completed { [true, false].sample }
    rank { Frame.ranks.keys.sample }
    game
    score { rand(0..10) }

    trait :completed do
      completed { true }
    end
    trait :normal do
      rank { :normal }
    end
    trait :strike do
      rank { :strike }
    end
    trait :spare do
      rank { :spare }
    end
  end
end
