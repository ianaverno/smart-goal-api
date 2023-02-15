class StatResource < JSONAPI::Resource
  attributes :value, :date

  belongs_to :goal
end