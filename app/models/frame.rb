class Frame < ApplicationRecord
  MAX_AVAILABLE_SHOTS_COUNT = 3.freeze

  belongs_to :game
  has_many :shots

  enum rank: %i[normal strike spare]

  validates_numericality_of :score, less_than_or_equal_to: 30

  def complete
    self.completed = true
  end

  def complete!
    complete
    self.save!
  end

  def add_to_score!(pins)
    self.score += pins
    self.save!
  end

  def complete_and_add_to_score!(pins)
    complete
    add_to_score!(pins)
  end

  def final_frame_of_the_game?
    (game.frames.last == self) && (game.frames.count == Game::MAX_FRAMES)
  end
end
