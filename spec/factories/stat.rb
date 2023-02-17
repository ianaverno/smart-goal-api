FactoryBot.define do
  factory :stat do
    trait :valid do
      association :goal, :valid
      date  { Date.today }
      value { 3.5 }
    end

    trait :in_future do
      association :goal, :valid
      date  { Date.today + 1.day }
    end
  end
end