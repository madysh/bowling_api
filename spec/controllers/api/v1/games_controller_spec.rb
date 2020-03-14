require 'spec_helper'

describe Api::V1::GamesController, type: :controller do
  describe "#create" do
    subject { post :create }

    it "creates a new Game record" do
      expect { subject }.to change { Game.count }.by(1)
    end

    it "returns a json with new record's id"  do
      subject

      expect(parsed_response_body).to eq("id" => Game.last.id)
    end

    it "returns 201 status" do
      subject

      expect(response).to have_http_status(201)
    end
  end

  describe "#show" do
    let!(:game) { create(:game, :with_frames) }
    let(:game_id) { game.id }

    subject { get :show, params: { id: game_id } }

    context "there is no passed game" do
      let(:game_id) { Game.last.id + rand(1..10) }

      it "returns an empty json" do
        subject

        expect(parsed_response_body).to be_empty
      end

      it "returns 404 status" do
        subject

        expect(response).to have_http_status(404)
      end
    end

    it "returns game's json" do
      subject

      expect(parsed_response_body).to match(game.as_json)
    end

    it "returns 200 status" do
      subject

      expect(response).to have_http_status(200)
    end
  end
end
