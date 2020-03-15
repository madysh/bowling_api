require 'rails_helper'

RSpec.describe "Shots routing", type: :routing do
  describe "POST create" do
    let(:game_id) { rand(1..100) }

    it do
      expect(post: "/games/#{game_id}/shots").to route_to(
        controller: "shots",
        action: "create",
        game_id: game_id
      )
    end
  end
end
