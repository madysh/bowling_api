class Api::V1::ShotsController < ApplicationController

  # POST /api/v1/games/:game_id/shots
  def create
    render json: {}, status: :created
  end
end
