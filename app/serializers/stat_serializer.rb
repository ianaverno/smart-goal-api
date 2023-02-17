class StatSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :value, :date, :url

  def url
    api_v1_goal_stat_url(object.goal, object)
  end
end