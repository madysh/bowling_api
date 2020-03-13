require 'rails_helper'

RSpec.describe 'Api::V1::Shots routing', type: :routing do
  describe "POST create" do
    it do
      expect(post: "/api/v1/games/1/shots").to route_to(
        controller: "api/v1/shots",
        action: "create",
        game_id: "1",
        format: :json
      )
    end
  end
end
