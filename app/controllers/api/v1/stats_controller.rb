class Api::V1::StatsController < ApplicationController
  before_action :set_stat

  def update
    if @stat.update(stat_params)
      render json: @stat, status: :ok
    else
      render json: { errors: @stat.errors }, status: :unprocessable_entity
    end
  end

  private 

    def set_stat
      goal = Goal.find(params[:goal_id])
      @stat = goal.stats.find(params[:id])
    end

    def stat_params
      params.require(:stat).permit(:value)
    end
end