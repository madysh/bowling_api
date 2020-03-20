class Game < ApplicationRecord
  MAX_FRAMES = 10.freeze
  MAX_SCORE_VALUE = 300.freeze

  include ScoreHolder

  has_many :frames

  validates_numericality_of :score, less_than_or_equal_to: MAX_SCORE_VALUE

  def as_json(*)
    super
      .slice(*%w[id score completed])
      .merge(
        "frames" => frames.order(:id).map(&:as_json),
        "available_pins" => PinsCounter.available_pins(self)
      )
  end
end
