require 'spec_helper'

describe Api::V1::ShotsController, type: :controller do
  describe "#create" do
    subject { post :create, params: { game_id: 1 } }

    it 'returns 201 status'  do
      subject

      expect(response).to have_http_status(201)
    end
  end
end
