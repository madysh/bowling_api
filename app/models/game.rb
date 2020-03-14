class Game < ApplicationRecord
  MAX_FRAMES = 10.freeze
  MAX_SCORE_VALUE = 300.freeze

  has_many :frames

  validates_numericality_of :score, less_than_or_equal_to: MAX_SCORE_VALUE

  def complete!
    update(completed: true)
  end

  def add_to_score!(pins)
    self.score += pins
    self.save!
  end

  def as_json(*)
    super
      .slice(*%w[id score completed])
      .merge("frames" => frames.order(:id).map(&:as_json))
  end
end
