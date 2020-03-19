module ScoreHolder
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
end
