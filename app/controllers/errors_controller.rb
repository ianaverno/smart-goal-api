class ErrorsController < ApplicationController

  def not_found
    render json: { error: 'invalid route' }, status: :not_found
  end
end