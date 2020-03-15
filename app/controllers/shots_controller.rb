class ShotsController < ApplicationController

  # POST /games/:game_id/shots
  def create
    @api_response = api_agent.make_shot(params[:game_id], params[:pins])

    respond_to do |format|
      format.js
    end
  end
end
