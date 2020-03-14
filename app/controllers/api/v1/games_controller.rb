class Api::V1::GamesController < ApplicationController

  # POST /api/v1/games
  def create
    render json: { id: (Game.create!).id }, status: :created
  end

  # GET /api/v1/games/:id
  def show
    game = Game.find_by(id: params[:id])

    if game
      render json: game
    else
      render json: {}, status: 404
    end
  end
end
