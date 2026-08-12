class CreatePlayers < ActiveRecord::Migration[8.1]
  def change
    create_table :players do |t|
      t.references :room, null: false, foreign_key: { to_table: :rooms }
      t.string :seat, null: false
      t.string :token, null: false
      t.string :name, null: false
      t.integer :score, null: false, default: 0

      t.timestamps

      t.index [ :room_id, :seat ], unique: true
      t.index :token, unique: true
    end
  end
end
