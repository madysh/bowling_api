require 'rails_helper'

RSpec.describe Frame, type: :model do
  it { should belong_to(:game) }

  it { should define_enum_for(:rank).with_values(%i[normal strike spare]) }
  it { should validate_numericality_of(:score).is_less_than_or_equal_to(30) }
end
