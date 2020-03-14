class AddScoreToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :score, :integer, after: :completed, default: 0
  end
end
