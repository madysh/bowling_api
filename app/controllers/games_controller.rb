class GamesController < ApplicationController

  # GET /games
  def index
  end

  # GET /games/new
  def new
  end

  # POST /games
  def create
    @game_id = api_agent.new_game
    @max_available_pins = Shot::MAX_PINS

    render :new
  end
end
