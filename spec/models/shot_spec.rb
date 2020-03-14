require 'rails_helper'

RSpec.describe Shot, type: :model do
  it { should belong_to(:frame) }

  it { should validate_numericality_of(:pins).is_less_than_or_equal_to(Shot::MAX_PINS) }

  describe "#as_json" do
    let(:shot) { build(:shot) }

    subject { shot.as_json }

    it "returns expected hash" do
      is_expected.to match("pins" => shot.pins)
    end
  end
end
