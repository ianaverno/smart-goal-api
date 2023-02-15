class Api::V1::GoalsController < ApplicationController
  before_action :set_goal, only: [:update, :destroy]

  def index
    render jsonapi: Goal.all, include: [:stats],
      fields: {
        goals: [:description, :target_date, :interval,
          :target_value, :starting_value]
      }
  end

  def create
  end

  def update
  end

  def destroy
  end

  private
    def set_goal
      @goal = Goal.find(params[:id])
    end

    def goal_params
      params.require(:goal).permit(:description, :target_date, :interval,
        :target_value, :starting_value)
    end
end
