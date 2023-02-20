class StatSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :value, :date, :url

  def url
    if object.due?
      api_v1_goal_stat_url(object.goal, object)
    else
      nil
    end
  end
end