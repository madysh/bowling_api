require 'rails_helper'

RSpec.describe 'Api::V1::Games routing', type: :routing do
  describe "POST create" do
    it do
      expect(post: "/api/v1/games").to route_to(
        controller: "api/v1/games",
        action: "create",
        format: :json
      )
    end
  end

  describe "GET show" do
    let(:id) { rand(1..100).to_s }

    it do
      expect(get: "/api/v1/games/#{id}").to route_to(
        controller: "api/v1/games",
        action: "show",
        id: id,
        format: :json
      )
    end
  end
end
