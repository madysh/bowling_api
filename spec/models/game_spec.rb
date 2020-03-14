require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game) { build(:game) }

  it { should have_many(:frames) }

  it { should validate_numericality_of(:score).is_less_than_or_equal_to(300) }

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
    let(:pins) { rand(0..10) }

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
end
