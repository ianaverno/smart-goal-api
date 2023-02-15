class GoalResource < JSONAPI::Resource
  attributes :description, :starting_value, :target_value, :target_date, :interval

  has_many :stats
end