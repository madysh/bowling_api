class Game < ApplicationRecord
  MAX_FRAMES = 10.freeze

  has_many :frames

  def complete!
    update(completed: true)
  end
end
