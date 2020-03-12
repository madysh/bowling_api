class CreateFrames < ActiveRecord::Migration[6.0]
  def change
    create_table :frames do |t|
      t.belongs_to :game
      t.integer :rank, default: 0
      t.boolean :completed, default: false
      t.integer :score, default: 0

      t.timestamps
    end
  end
end
