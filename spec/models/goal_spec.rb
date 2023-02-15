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
require 'rails_helper'

RSpec.describe Goal, type: :model do
  subject do
    described_class.new(
      description:     'Work more',
      target_date:     Date.today + 1.year,
      unit_of_measure: 'hours a day',
      starting_value:  2.5,
      target_value:    8,
      interval:        'daily'
    )
  end

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it 'has a non-empty description' do
    subject.description = nil
    expect(subject).not_to be_valid

    subject.description = ""
    expect(subject).not_to be_valid
  end

  it 'has a target date in future' do
    subject.target_date = nil
    expect(subject).not_to be_valid

    subject.target_date = Date.today
    expect(subject).not_to be_valid

    subject.target_date = Date.yesterday
    expect(subject).not_to be_valid
  end

  it 'can be unitless' do
    subject.unit_of_measure = nil
    expect(subject).to be_valid
  end

  it 'has a valid starting value' do
    subject.starting_value = nil
    expect(subject).not_to be_valid

    subject.starting_value = -2.3
    expect(subject).to be_valid
  end

  it 'has a valid target value' do
    subject.target_value = nil
    expect(subject).not_to be_valid

    subject.target_value = -9
    expect(subject).to be_valid
  end

  it 'has a valid control interval' do
    subject.interval = nil
    expect(subject).not_to be_valid
    
    subject.interval = "hourly"
    expect(subject).not_to be_valid

    subject.interval = "monthly"
    expect(subject).to be_valid

    subject.interval = "weekly"
    expect(subject).to be_valid

    subject.interval = "yearly"
    expect(subject).to be_valid
  end
end
