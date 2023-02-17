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

  validates :value, numericality: true, allow_nil: true
  validates :date, presence: true
  validate :historic_data?

  default_scope { order(:date) }
  scope :due, -> { where('date <= ?', Date.today) }

  private

  def historic_data?
    if date && date > Date.today && value.present?
      errors.add(:value, "cannot be set before occurence")
    end
  end
end
