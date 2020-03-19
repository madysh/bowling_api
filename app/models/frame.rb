class Frame < ApplicationRecord
  MAX_AVAILABLE_SHOTS_COUNT = 3.freeze

  include ScoreHolder

  belongs_to :game
  has_many :shots

  enum rank: %i[normal strike spare]

  validates_numericality_of :score, less_than_or_equal_to: 30

  def final_frame_of_the_game?
    (game.frames.last == self) && (game.frames.count == Game::MAX_FRAMES)
  end

  def as_json(*)
    super
      .slice(*%w[rank score completed])
      .merge("shots" => shots.order(:id).map(&:as_json))
  end
end
