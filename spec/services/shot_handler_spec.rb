require 'rails_helper'
require "#{Rails.root}/spec/support/shared_examples/shot_handler_shared_examples"

RSpec.describe ShotHandler do
  let!(:game) { create(:game, :not_completed, score: 0) }
  let(:game_id) { game.id }
  let(:pins) { rand(0..Shot::MAX_PINS) }
  let(:instance) { ShotHandler.new(game_id) }

  describe "#handle" do
    subject { instance.handle(pins) }

    context "with exceptions" do
      context "there is no game with passed id" do
        let(:game_id) { Game.last.id + rand(1..10) }

        it "raices ShotHandler::GameNotFindError error" do
          expect { subject }.to raise_error(ShotHandler::GameNotFindError)
        end
      end

      context "with wrong number of pins" do
        let(:pins) { Shot::MAX_PINS + rand(1..10) }

        it "raices ShotHandler::ArgumentError error" do
          expect { subject }.to raise_error(ShotHandler::ArgumentError)
        end
      end

      context "game is completed" do
        before do
          game.complete!
        end

        it "raices ShotHandler::GameIsOverError error" do
          expect { subject }.to raise_error(ShotHandler::GameIsOverError)
        end
      end
    end

    context "first shot" do
      before do
        game.frames.delete_all
      end

      context "with strike shot" do
        let(:pins) { Shot::MAX_PINS }

        it_behaves_like :creates_frame, "strike"
        it_behaves_like :creates_shot
        it_behaves_like :updates_games_score
      end

      context "with not strike shot" do
        let(:pins) { rand(0..Shot::MAX_PINS-1) }

        it_behaves_like :creates_frame, "normal"
        it_behaves_like :creates_shot
        it_behaves_like :updates_games_score
      end
    end

    context "second shot" do
      let(:first_shot_pins) { rand(0..Shot::MAX_PINS-2) }
      let(:previous_frame) { game.reload.frames.last }

      before do
        game.frames.delete_all
        instance.handle(first_shot_pins)
      end

      context "with spare shot" do
        let(:pins) { Shot::MAX_PINS - first_shot_pins }

        it_behaves_like :updates_frame, "spare" do
          let(:expected_pins) { Shot::MAX_PINS }
        end
        it_behaves_like :creates_shot do
          let(:frame_id) { previous_frame.id }
        end
        it_behaves_like :updates_games_score
      end

      context "with not spare shot" do
        let(:pins) { rand(0..(Shot::MAX_PINS - first_shot_pins - 1)) }

        it_behaves_like :updates_frame, "normal", true do
          let(:expected_pins) { first_shot_pins + pins }
        end
        it_behaves_like :creates_shot
        it_behaves_like :updates_games_score
      end
    end

    context "last frame" do
      before do
        game.frames.delete_all
        create_list(:frame, Game::MAX_FRAMES - 3, :with_shots, :completed, game: game)
      end

      context "there are no spares and strikes before" do
        before do
          create_list(:frame, 2, :normal, :with_shots, :completed, game: game)
        end

        context "with one strike shot" do
          let(:pins) { Shot::MAX_PINS }

          it_behaves_like :creates_frame, "strike"
          it_behaves_like :creates_shot
          it_behaves_like :updates_games_score
          it_behaves_like :does_not_complete_game
        end

        context "with two strike shot" do
          let(:pins) { Shot::MAX_PINS }

          before do
            instance.handle(pins)
          end

          it_behaves_like :updates_frame, "strike" do
            let(:expected_pins) { 2*pins }
          end
          it_behaves_like :creates_shot
          it_behaves_like :updates_games_score
          it_behaves_like :does_not_complete_game
        end

        context "with three strike shots" do
          let(:pins) { Shot::MAX_PINS }

          before do
            2.times { instance.handle(pins) }
          end

          it_behaves_like :updates_frame, "strike", true do
            let(:expected_pins) { 3*pins }
          end
          it_behaves_like :creates_shot
          it_behaves_like :updates_games_score
          it_behaves_like :completes_game
        end
      end

      #TODO cover more cases
    end
  end
end
