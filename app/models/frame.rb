class Frame < ApplicationRecord
  belongs_to :game

  enum rank: %i[common strike spare]

  validates_numericality_of :score, less_than_or_equal_to: 30
end
