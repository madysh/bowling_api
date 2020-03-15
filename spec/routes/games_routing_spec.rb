require 'rails_helper'

RSpec.describe "Games routing", type: :routing do
  describe "GET index" do
    it { expect(get: "/games").to route_to(controller: "games", action: "index") }
  end

  describe "GET new" do
    it { expect(get: "/games/new").to route_to(controller: "games", action: "new") }
  end

  describe "POST create" do
    it { expect(post: "/games").to route_to(controller: "games", action: "create") }
  end
end
