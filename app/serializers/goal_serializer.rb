class GoalSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :description, :target_date, :interval, 
    :target_value, :starting_value, :unit_of_measure, :url

  has_many :stats

  def url
    api_v1_goal_url(object)
  end
end