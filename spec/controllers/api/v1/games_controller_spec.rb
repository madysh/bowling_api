require 'spec_helper'

describe Api::V1::GamesController, type: :controller do
  describe "#create" do
    subject { post :create }

    it 'creates a new Game record' do
      expect { subject }.to change { Game.count }.by(1)
    end

    it 'returns a json with new record\'s id'  do
      subject

      expect(parsed_response_body).to eq({ 'id' => Game.last.id })
    end

    it 'returns 201 status'  do
      subject

      expect(response).to have_http_status(201)
    end
  end
end
