class AddRoundsToRooms < ActiveRecord::Migration[8.1]
  def change
    add_column :rooms, :round_number, :integer, default: 0
  end
end
