class AddDrawerAndGuesserToRooms < ActiveRecord::Migration[8.1]
  def change
    add_reference :rooms, :drawer_player, foreign_key: { to_table: :players }
    add_reference :rooms, :guesser_player, foreign_key: { to_table: :players }
  end
end
