class Shot < ApplicationRecord
  MAX_PINS = 10.freeze

  belongs_to :frame

  validates_numericality_of :pins, less_than_or_equal_to: MAX_PINS

  def as_json(*)
    super.slice("pins")
  end
end
