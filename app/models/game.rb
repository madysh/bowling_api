class Game < ApplicationRecord
  MAX_FRAMES = 10.freeze

  has_many :frames

  validates_numericality_of :score, less_than_or_equal_to: 300

  def complete!
    update(completed: true)
  end
end
