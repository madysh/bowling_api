module PinsCounter
  def self.available_pins(game)
    last_frame = game.frames.last
    last_shot_pins = last_frame&.shots&.last&.pins

    case
     when game.completed? then 0
     when last_frame.nil? || last_frame.completed? || last_frame.spare? then Shot::MAX_PINS
     when last_frame.normal? then Shot::MAX_PINS - last_shot_pins
     when last_shot_pins == Shot::MAX_PINS then Shot::MAX_PINS
     else Shot::MAX_PINS - last_shot_pins
    end
  end
end
