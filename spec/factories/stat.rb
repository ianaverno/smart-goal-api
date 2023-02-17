FactoryBot.define do
  factory :stat do
    trait :valid do
      association :goal, :valid
      date  { Date.today }
      value { 3.5 }
    end
  end
end