require 'rails_helper'

RSpec.describe Shot, type: :model do
  it { should belong_to(:frame) }

  it { should validate_numericality_of(:pins).is_less_than_or_equal_to(10) }
end
