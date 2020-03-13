require 'rails_helper'

RSpec.describe Game, type: :model do
  it { should have_many(:frames) }

  describe "#complete!" do
    let(:game) { build(:game) }

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
end
