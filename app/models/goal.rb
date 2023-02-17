# == Schema Information
#
# Table name: goals
#
#  id              :bigint           not null, primary key
#  description     :string
#  interval        :string
#  starting_value  :float
#  target_date     :date
#  target_value    :float
#  unit_of_measure :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Goal < ApplicationRecord
  INTERVAL_OPTIONS = ["daily", "weekly", "monthly", "yearly"]

  has_many :stats, dependent: :destroy

  validates :description, presence: true
  validates :interval, inclusion: { in: INTERVAL_OPTIONS }
  validates :starting_value, :target_value, numericality: true
  validate  :target_date_in_future?, on: :create

  default_scope { order(created_at: :desc, target_date: :asc) }

  def self.interval_options
    INTERVAL_OPTIONS
  end

  private
    def target_date_in_future?
      unless target_date && target_date > Date.today
        errors.add(:target_date, "should be in the future")
      end
    end
end
