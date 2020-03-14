class ShotHandler
  class GameNotFindError < StandardError; end
  class GameIsOverError < StandardError; end
  class ArgumentError < StandardError; end

  def initialize(game_id)
    @game_id = game_id
  end

  def handle(pins)
    init_variables(pins)
    validate_passed_params
    frame = create_or_update_frames
    create_shot(frame)

    complete_game if game_over?
  end

  private

  attr_reader :pins, :previous_frame

  def game
    @game ||= Game.find_by(id: @game_id) || raise(GameNotFindError)
  end

  def init_variables(pins)
    @pins = pins
    @previous_frame = game.reload.frames.last
  end

  def validate_passed_params
    raise GameIsOverError if game.completed?
    raise ArgumentError if (0..Shot::MAX_PINS).exclude?(pins)
  end

  def create_or_update_frames
    case
      when previous_frame.nil? || previous_frame.completed? then try_to_create_new_frame
      when previous_frame.normal? then update_normal_frame
      when previous_frame.spare? then update_spare_frame
      when previous_frame.strike? then update_strike_frame
    end
  end

  def strike?
    pins == Shot::MAX_PINS
  end

  def try_to_create_new_frame
    return previous_frame if previous_frame&.final_frame_of_the_game?

    rank = strike? ? :strike : :normal
    frame = game.frames.where(completed: false, rank: rank, score: pins).create!

    game.add_to_score!(pins)

    frame
  end

  def update_normal_frame
    if (previous_frame.shots.first.pins + pins == Shot::MAX_PINS)
      previous_frame.spare!
    else
      previous_frame.complete
    end

    previous_frame.add_to_score!(pins)
    game.add_to_score!(pins)
    previous_frame
  end

  def update_spare_frame
    previous_frame.complete_and_add_to_score!(pins)
    game.add_to_score!(pins)
    try_to_create_new_frame
  end

  def update_strike_frame
    one_frame_before = game.frames.where.not(id: previous_frame.id).last

    if one_frame_before && !one_frame_before.completed? && one_frame_before.strike?
      one_frame_before.complete_and_add_to_score!(pins)
      game.add_to_score!(pins)
    end

    previous_frame.add_to_score!(pins)
    game.add_to_score!(pins)
    try_to_create_new_frame
  end

  def create_shot(frame)
    frame.shots.where(pins: pins).create!
  end

  def game_over?
    return false if previous_frame.nil?
    return false unless previous_frame.final_frame_of_the_game?
    return true if previous_frame.completed?

    previous_frame.shots.count == Frame::MAX_AVAILABLE_SHOTS_COUNT
  end

  def complete_game
    previous_frame.complete!
    game.complete!
  end
end
