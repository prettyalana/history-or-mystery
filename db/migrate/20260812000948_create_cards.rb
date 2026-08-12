class CreateCards < ActiveRecord::Migration[8.1]
  def change
    create_table :cards do |t|
      t.string :category, null: false
      t.string :title, null: false
      t.text :fact, null: false
      t.string :clue, null: false

      t.timestamps
    end
  end
end
