require 'rails_helper'

RSpec.describe 'Api::V1::Shots routing', type: :routing do
  let(:game_id) { rand(1..100).to_s }

  describe "POST create" do
    it do
      expect(post: "/api/v1/games/#{game_id}/shots").to route_to(
        controller: "api/v1/shots",
        action: "create",
        game_id: game_id,
        format: :json
      )
    end
  end
end
