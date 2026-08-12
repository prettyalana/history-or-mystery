class CreateRooms < ActiveRecord::Migration[8.1]
  def change
    create_table :rooms do |t|
      t.string :code
      t.string :status
      t.references :current_card, foreign_key: { to_table: :cards }
      t.datetime :round_started_at
      t.boolean :clue_revealed
      t.string :round_status
      t.integer :used_card_ids, array: true, default: []

      t.timestamps
    end
  end
end
