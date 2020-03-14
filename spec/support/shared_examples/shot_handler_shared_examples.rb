shared_examples :creates_shot do
  let(:frame_id) { game.reload.frames.last.id }

  it "creates expected Shot" do
    expect { subject }.to change { Shot.count }.by(1)

    expect(Shot.last).to have_attributes(
      frame_id: frame_id,
      pins: pins
    )
  end
end

shared_examples :updates_games_score do
  it "updates Game's score" do
    expect { subject }.to change { game.reload.score }.by(pins)
  end
end

shared_examples :does_not_complete_game do
  it "doesn't complete Game" do
    expect { subject }.not_to change { game.reload.completed }
  end
end

shared_examples :completes_game do
  it "completes Game" do
    expect { subject }.to change { game.reload.completed }.to(true)
  end
end

shared_examples :creates_frame do |expeced_rank, completed = false|
  let(:expected_pins) { pins }

  it "creates expected Frame" do
    expect { subject }.to change { Frame.count }.by(1)

    expect(Frame.last).to have_attributes(
      game_id: game_id,
      rank: expeced_rank,
      score: expected_pins,
      completed: completed
    )
  end
end

shared_examples :updates_frame do |expeced_rank, completed = false|
  let(:expected_pins) { pins }

  it "updates Frame" do
    expect { subject }.not_to change { Frame.count }

    expect(Frame.last).to have_attributes(
      game_id: game_id,
      rank: expeced_rank,
      score: expected_pins,
      completed: completed
    )
  end
end
