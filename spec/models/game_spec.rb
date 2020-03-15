require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game) { build(:game) }

  it { should have_many(:frames) }

  it { should validate_numericality_of(:score).is_less_than_or_equal_to(Game::MAX_SCORE_VALUE) }

  describe "#complete!" do
    subject { game.complete! }

    context "for new record" do
      context "game is completed" do
        before do
          game.completed = true
        end

        it "saves the record" do
          expect { subject }.to change { game.new_record? }.from(true).to(false)
        end

        it "doesn't change completed value" do
          expect { subject }.not_to change { game.completed }.from(true)
        end
      end

      context "game is not completed" do
        before do
          game.completed = false
        end

        it "saves the record" do
          expect { subject }.to change { game.new_record? }.from(true).to(false)
        end

        it "changes completed value" do
          expect { subject }.to change { game.completed }.from(false).to(true)
        end
      end
    end

    context "for existed record" do
      context "game is completed" do
        before do
          game.completed = true
          game.save!
        end

        it "doesn't change completed value" do
          expect { subject }.not_to change { game.completed }.from(true)
        end
      end

      context "game is not completed" do
        before do
          game.completed = false
          game.save!
        end

        it "changes completed value" do
          expect { subject }.to change { game.completed }.from(false).to(true)
        end
      end
    end
  end

  describe "#add_to_score!" do
    let(:pins) { rand(0...Game::MAX_SCORE_VALUE - game.score) }

    subject { game.add_to_score!(pins) }

    context "for new record" do
      it "adds passed value to score" do
        expect { subject }.to change { game.score }.by(pins)
      end

      it "saves the record" do
        expect { subject }.to change { game.new_record? }.from(true).to(false)
      end
    end

    context "for existed record" do
      before do
        game.save!
      end

      it "adds passed value to score" do
        expect { subject }.to change { game.score }.by(pins)
      end
    end
  end

  describe "#as_json" do
    let(:game) { build(:game, :not_completed, id: rand(1..100)) }

    subject { game.as_json }

    context "with random game" do
      let(:frames) { create_list(:frame, rand(1..Game::MAX_FRAMES), :with_shots, game: game) }

      before do
        game.frames << frames
      end

      it "returns expected hash" do
        is_expected.to match(expected_games_json)
      end
    end

    context "for completed game" do
      before do
        game.completed = true
      end

      it "returns expected hash" do
        is_expected.to match(expected_games_json(available_pins: 0))
      end
    end

    context "for new game" do
      it "returns expected hash" do
        is_expected.to match(expected_games_json(available_pins: Shot::MAX_PINS))
      end
    end

    context "when the last frame is strike" do
      before do
        game.frames << create(:frame, :strike, :completed, game: game)
      end

      it "returns expected hash" do
        is_expected.to match(expected_games_json(available_pins: Game::MAX_FRAMES))
      end
    end

    context "for bonus shot" do
      let(:frames) { create_list(:frame, Game::MAX_FRAMES-1, :with_shots, game: game) }

      before do
        game.frames << frames
      end

      context "for strike frame" do
        before do
          strike = create(:frame, :strike, :not_completed, game: game)
          game.frames << strike

          create(:shot, pins: Shot::MAX_PINS, frame: strike)
          create(:shot, pins: 3, frame: strike)
        end

        it "returns expected hash" do
          is_expected.to match(
            expected_games_json(available_pins: 7)
          )
        end
      end

      context "for spare frame" do
        before do
          spare = create(:frame, :spare, :not_completed, game: game)
          game.frames << spare

          create_list(:shot, 2, pins: 5, frame: spare)
        end

        it "returns expected hash" do
          is_expected.to match(
            expected_games_json(available_pins: Shot::MAX_PINS)
          )
        end
      end
    end
  end

  def expected_games_json(args={})
    {
      id: game.id,
      score: game.score,
      completed: game.completed,
      available_pins: anything,
      frames: game.frames.map do |f|
        {
          rank: f.rank,
          score: f.score,
          completed: f.completed,
          shots: f.shots.map { |s| { pins: s.pins } }
        }
      end
    }.merge(args).deep_stringify_keys
  end
end
