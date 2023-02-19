class GoalTracker
  INCREMENTS = {
    "daily" => :day, 
    "weekly" => :week, 
    "monthly" => :month, 
    "yearly" => :year
  }

  def initialize(goal)
    puts goal.inspect
    @goal = goal
  end

  def create_tracking_schedule
    ActiveRecord::Base.transaction do
      control_date = @goal.created_at

      while control_date < @goal.target_date
        control_date += 1.send(INCREMENTS[@goal.interval])

        unless control_date >= @goal.target_date
          @goal.stats.create(date: control_date)
        end
      end

      @goal.stats.create(date: @goal.target_date)
    end
  end
end