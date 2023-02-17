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
require 'rails_helper'

RSpec.describe Stat, type: :model do
  subject { build(:stat, :valid) }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'belongs to a goal' do
    subject.goal = nil
    expect(subject).not_to be_valid

    subject.goal_id = "k233jk12"
    expect(subject).not_to be_valid
  end

  it 'has a date' do
    subject.date = nil
    expect(subject).not_to be_valid
  end

  it 'does not allow value tracking if the date is in future' do
    subject.date = Date.today + 1.day
    expect(subject).not_to be_valid

    # allow placeholders
    subject.value = nil
    expect(subject).to be_valid
  end
end
