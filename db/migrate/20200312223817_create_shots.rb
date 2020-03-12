class CreateShots < ActiveRecord::Migration[6.0]
  def change
    create_table :shots do |t|
      t.belongs_to :frame
      t.integer :pins, default: 0, limit: 1

      t.timestamps
    end
  end
end
