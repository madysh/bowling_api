class ChangeLimitOfRankAndScoreInFrames < ActiveRecord::Migration[6.0]
  def up
    change_column :frames, :rank, :integer, limit: 1
    change_column :frames, :score, :integer, limit: 1
  end

  def down
    change_column :frames, :rank, :integer
    change_column :frames, :score, :integer
  end
end
