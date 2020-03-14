require 'rails_helper'

RSpec.describe Frame, type: :model do
  it { should belong_to(:game) }
  it { should have_many(:shots) }

  it { should define_enum_for(:rank).with_values(%i[normal strike spare]) }
  it { should validate_numericality_of(:score).is_less_than_or_equal_to(30) }

  let(:frame) { build(:frame) }

  describe "#complete" do
    subject { frame.complete }

    context "for new record" do
      context "frame is completed" do
        before do
          frame.completed = true
        end

        it "doesn't save the record" do
          expect { subject }.not_to change { frame.new_record? }.from(true)
        end

        it "doesn't change completed value" do
          expect { subject }.not_to change { frame.completed }.from(true)
        end
      end

      context "frame is not completed" do
        before do
          frame.completed = false
        end

        it "doesn't save the record" do
          expect { subject }.not_to change { frame.new_record? }.from(true)
        end

        it "changes completed value" do
          expect { subject }.to change { frame.completed }.from(false).to(true)
        end
      end
    end

    context "for existed record" do
      context "frame is completed" do
        before do
          frame.completed = true
          frame.save!
        end

        it "doesn't change completed value" do
          expect { subject }.not_to change { frame.completed }.from(true)
        end
      end

      context "frame is not completed" do
        before do
          frame.completed = false
          frame.save!
        end

        it "changes completed value" do
          expect { subject }.to change { frame.completed }.from(false).to(true)
        end
      end
    end
  end

  describe "#complete!" do
    subject { frame.complete! }

    context "for new record" do
      context "frame is completed" do
        before do
          frame.completed = true
        end

        it "saves the record" do
          expect { subject }.to change { frame.new_record? }.from(true).to(false)
        end

        it "doesn't change completed value" do
          expect { subject }.not_to change { frame.completed }.from(true)
        end
      end

      context "frame is not completed" do
        before do
          frame.completed = false
        end

        it "saves the record" do
          expect { subject }.to change { frame.new_record? }.from(true).to(false)
        end

        it "changes completed value" do
          expect { subject }.to change { frame.completed }.from(false).to(true)
        end
      end
    end

    context "for existed record" do
      context "frame is completed" do
        before do
          frame.completed = true
          frame.save!
        end

        it "doesn't change completed value" do
          expect { subject }.not_to change { frame.completed }.from(true)
        end
      end

      context "frame is not completed" do
        before do
          frame.completed = false
          frame.save!
        end

        it "changes completed value" do
          expect { subject }.to change { frame.completed }.from(false).to(true)
        end
      end
    end
  end

  describe "#add_to_score!" do
    let(:pins) { rand(0..10) }

    subject { frame.add_to_score!(pins) }

    context "for new record" do
      it "adds passed value to score" do
        expect { subject }.to change { frame.score }.by(pins)
      end

      it "saves the record" do
        expect { subject }.to change { frame.new_record? }.from(true).to(false)
      end
    end

    context "for existed record" do
      before do
        frame.save!
      end

      it "adds passed value to score" do
        expect { subject }.to change { frame.score }.by(pins)
      end
    end
  end

  describe "#complete_and_add_to_score!" do
    let(:pins) { rand(0..10) }

    subject { frame.complete_and_add_to_score!(pins) }

    context "for new record" do
      context "frame is completed" do
        before do
          frame.completed = true
        end

        it "saves the record" do
          expect { subject }.to change { frame.new_record? }.from(true).to(false)
        end

        it "doesn't change completed value" do
          expect { subject }.not_to change { frame.completed }.from(true)
        end

        it "adds passed value to score" do
          expect { subject }.to change { frame.score }.by(pins)
        end
      end

      context "frame is not completed" do
        before do
          frame.completed = false
        end

        it "saves the record" do
          expect { subject }.to change { frame.new_record? }.from(true).to(false)
        end

        it "changes completed value" do
          expect { subject }.to change { frame.completed }.from(false).to(true)
        end

        it "adds passed value to score" do
          expect { subject }.to change { frame.score }.by(pins)
        end
      end
    end

    context "for existed record" do
      context "frame is completed" do
        before do
          frame.completed = true
          frame.save!
        end

        it "doesn't change completed value" do
          expect { subject }.not_to change { frame.completed }.from(true)
        end

        it "adds passed value to score" do
          expect { subject }.to change { frame.score }.by(pins)
        end
      end

      context "frame is not completed" do
        before do
          frame.completed = false
          frame.save!
        end

        it "changes completed value" do
          expect { subject }.to change { frame.completed }.from(false).to(true)
        end

        it "adds passed value to score" do
          expect { subject }.to change { frame.score }.by(pins)
        end
      end
    end
  end

  describe "#final_frame_of_the_game?" do
    let(:game) { create(:game) }
    let(:frames) { create_list(:frame, Game::MAX_FRAMES, game: game) }

    subject { frame.final_frame_of_the_game? }

    context "for 10th frame of the game" do
      let(:frame) { frames.last }

      it { is_expected.to be(true) }
    end

    context "for not 10th frame of the game" do
      let(:frame) { frames[0...-1].sample }

      it { is_expected.to be(false) }
    end
  end

  describe "#as_json" do
    let(:frame) { build(:frame) }
    let(:shots) { create_list(:shot, 2, frame: frame) }

    subject { frame.as_json }

    before do
      frame.shots << shots
    end

    it "returns expected hash" do
      is_expected.to match(
        "rank" => frame.rank,
        "score" => frame.score,
        "completed" => frame.completed,
        "shots" => shots.map { |s| { "pins" => s.pins } }
      )
    end
  end
end
