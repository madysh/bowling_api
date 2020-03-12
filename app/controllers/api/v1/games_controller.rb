class Api::V1::GamesController < ApplicationController

  # POST /api/v1/games
  def create
    render json: { id: (Game.create!).id }, status: :created
  end
end
