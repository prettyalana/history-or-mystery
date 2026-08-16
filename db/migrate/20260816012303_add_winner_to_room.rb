class AddWinnerToRoom < ActiveRecord::Migration[8.1]
  def change
    add_reference :rooms, :winner_player, foreign_key: { to_table: :players,  on_delete: :nullify }
  end
end
