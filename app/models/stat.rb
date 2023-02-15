# == Schema Information
#
# Table name: stats
#
#  id         :bigint           not null, primary key
#  date       :date
#  value      :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  goal_id    :bigint           not null
#
# Indexes
#
#  index_stats_on_goal_id  (goal_id)
#
# Foreign Keys
#
#  fk_rails_...  (goal_id => goals.id)
#
class Stat < ApplicationRecord
  belongs_to :goal
end
