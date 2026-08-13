class SetPlayerReferencesToNullOnRoom < ActiveRecord::Migration[8.1]
  def change
    remove_foreign_key :rooms, column: :drawer_player_id
    remove_foreign_key :rooms, column: :guesser_player_id

    add_foreign_key :rooms, :players,
      column: :drawer_player_id,
      on_delete: :nullify

    add_foreign_key :rooms, :players,
      column: :guesser_player_id,
      on_delete: :nullify
  end
end
