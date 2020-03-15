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
      .merge(
        "frames" => frames.order(:id).map(&:as_json),
        "available_pins" => available_pins
      )
  end

  private

  def available_pins
    case
     when completed? then 0
     when frames.last.nil? || frames.last.completed? || frames.last.spare? then Shot::MAX_PINS
     when frames.last.normal? then Shot::MAX_PINS - frames.last.shots.last.pins
     when frames.last.shots.last.pins == Shot::MAX_PINS then Shot::MAX_PINS
     else Shot::MAX_PINS - frames.last.shots.last.pins
    end
  end
end
