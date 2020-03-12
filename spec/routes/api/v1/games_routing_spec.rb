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
end
