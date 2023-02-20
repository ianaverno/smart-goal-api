## Generated with Chat GPT, with minor adjustments

# Goal.destroy_all
# Define a list of possible goal intervals
intervals = ["daily", "weekly", "monthly", "yearly"]

# Define a list of unit of measure options
units_of_measure = ["pounds", "minutes", "dollars", "steps", "calories"]

# Define a list of SMART goal descriptions, one for each interval/unit of measure combination
descriptions = {
  "daily:pounds" => "Lose 1 pound per week by reducing daily caloric intake by 500 calories",
  "daily:minutes" => "Exercise for 30 minutes every day for the next month to improve cardiovascular health",
  "daily:dollars" => "Save $10 per day for the next year to build an emergency fund",
  "daily:steps" => "Walk 10,000 steps every day for the next 3 months to improve fitness level",
  "daily:calories" => "Limit daily caloric intake to 1500 calories per day for the next 6 months to lose weight",
  "weekly:pounds" => "Lose 2 pounds per month by reducing weekly caloric intake by 1000 calories",
  "weekly:minutes" => "Exercise for 120 minutes per week for the next 3 months to improve flexibility",
  "weekly:dollars" => "Save $50 per week for the next year to pay off debt",
  "weekly:steps" => "Walk 50,000 steps per week for the next 6 months to train for a 10K race",
  "weekly:calories" => "Burn 5000 calories per week through exercise for the next 6 months to improve fitness level",
  "monthly:pounds" => "Lose 5 pounds by the end of the month by reducing monthly caloric intake by 2000 calories",
  "monthly:minutes" => "Exercise for 300 minutes per month for the next year to improve overall health",
  "monthly:dollars" => "Save $500 per month for the next year to save for a down payment on a house",
  "monthly:steps" => "Walk 250,000 steps per month for the next 6 months to train for a half marathon",
  "monthly:calories" => "Limit monthly caloric intake to 45,000 calories per month for the next year to lose weight",
  "yearly:pounds" => "Lose 20 pounds by the end of the year by reducing yearly caloric intake by 50,000 calories",
  "yearly:minutes" => "Exercise for 1000 minutes per year to improve overall fitness",
  "yearly:dollars" => "Save $10,000 per year to build a retirement fund",
  "yearly:steps" => "Walk 1 million steps per year to improve overall health",
  "yearly:calories" => "Burn 100,000 calories per year through exercise to maintain weight",
}

# Generate 30 goal records with random values for all fields
30.times do
  # Choose a random interval, description, and unit of measure
  interval = intervals.sample
  unit_of_measure = units_of_measure.sample
  description = descriptions["#{interval}:#{unit_of_measure}"]

  # Choose a random starting value between -1000 and 1000
  starting_value = rand(0..1000)

  # Choose a random target value between -1000 and 1000
  target_value = rand(1000..10000)

  # Choose a random created_at date between 6 months and 2 weeks ago
  

  # Choose a random target_date between 3 months from now and 1 year from now
  if interval == 'yearly'
    target_date = rand(1.year.from_now..10.years.from_now)
    created_at_mock = rand(10.years.ago..Time.now)
  else
    target_date = rand(3.months.from_now..1.year.from_now)
    created_at_mock = rand(1.year.ago..Time.now)
  end

  # Create the goal record with the chosen values
  goal = Goal.create!(
    interval: interval,
    unit_of_measure: unit_of_measure,
    description: description,
    starting_value: starting_value,
    target_value: target_value,
    target_date: target_date
  )

  
  goal.update_column(:created_at, created_at_mock)
  
  if rand < 0.5
    target_date_mock = rand(goal.created_at.to_date..Date.today)
    goal.update_column(:target_date, target_date_mock)
  end
  
  puts "Goal generated: #{goal.inspect}"

  # Create the tracking schedule for the goal
  tracker = GoalTracker.new(goal)
  tracker.create_tracking_schedule

  # Update the value of the stats associated with the goal to simulate progress
  goal.stats.due.each do |stat|

    # Choose a random value between the starting and target values
    value = rand(starting_value..target_value)

    # Update the value of the stat
    stat.update_columns(value: value)
  end
end