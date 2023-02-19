class Api::V1::GoalsController < ApplicationController
  before_action :set_goal, only: :destroy

  def index
    @goals = Goal.all.includes(:stats)
    render json: @goals, include: :stats
  end

  def create
    @goal = Goal.new(goal_params)

    if @goal.save
      tracker = GoalTracker.new(@goal)
      tracker.create_tracking_schedule

      render json: @goal, status: :created
    else
      render json: { error: 'create failed', details: @goal.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if @goal.destroy
      render json: @goal, status: :ok
    else
      render json: @goal.errors
    end
  end

  private
    def set_goal
      @goal = Goal.find(params[:id])
    end

    def goal_params
      params.require(:goal).permit(
        :description, :target_date, :interval, :target_value, :starting_value
      )
    end
end
