class Api::V1::ShotsController < ApplicationController

  # POST /api/v1/games/:game_id/shots
  def create
    game = handle_shot

    unless performed?
      render json: game, status: :created
    end
  end

  private

  def handle_shot
    ShotHandler.new(params[:game_id]).handle(params[:pins])
  rescue ShotHandler::GameIsOverError
    render_error("this game is competed")
  rescue ShotHandler::GameNotFindError
    render_error("there is no game with this id")
  rescue ShotHandler::ArgumentError => e
    render_error(e.message)
  end

  def render_error(message, status = 409)
    render json: { error: message }, status: status
  end
end
