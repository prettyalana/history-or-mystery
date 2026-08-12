class RemoveClueFromCardsAndAddClueTextToRooms < ActiveRecord::Migration[8.1]
  def change
    remove_column :cards, :clue, :string
    add_column :rooms, :clue_text, :text
  end
end
