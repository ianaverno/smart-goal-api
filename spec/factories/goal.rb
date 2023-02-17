FactoryBot.define do
  factory :goal do
    trait :valid do
      description     { 'Work more' }
      target_date     { Date.today + 1.year }
      unit_of_measure { 'hours a day' }
      starting_value  { 2.5 }
      target_value    { 8 }
      interval        { 'daily' }
    end
  end
end