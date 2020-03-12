class Shot < ApplicationRecord
  belongs_to :frame

  validates_numericality_of :pins, less_than_or_equal_to: 10
end
