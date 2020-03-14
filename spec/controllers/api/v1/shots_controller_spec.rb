require 'spec_helper'

describe Api::V1::ShotsController, type: :controller do
  shared_examples :returns_error do |message|
    it "returns json with error" do
      subject

      expect(response).to have_http_status(409)
      expect(parsed_response_body).to include(error: message)
    end
  end

  describe "#create" do
    let!(:game) { create(:game, :not_completed, :with_frames) }
    let(:game_id) { game.id }
    let(:pins) { rand(0..Shot::MAX_PINS) }

    subject { post :create, params: { game_id: game_id, pins: pins } }

    it "returns game as json" do
      subject

      expect(response).to have_http_status(201)
      expect(parsed_response_body).to match(game.reload.as_json)
    end

    context "with errors" do
      describe "game is completed" do
        before do
          game.complete!
        end

        it_behaves_like :returns_error, "this game is competed"
      end

      describe "there is no passed game" do
        let(:game_id) { Game.last.id + rand(1..10) }

        it_behaves_like :returns_error, "there is no game with this id"
      end

      describe "with wrong number of pins" do
        let(:pins) { Shot::MAX_PINS + rand(1..10) }

        it_behaves_like :returns_error, "wrong number of pins"
      end
    end
  end
end
