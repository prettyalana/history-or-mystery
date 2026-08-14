class AddIncorrectAnswersToCards < ActiveRecord::Migration[8.1]
  def change
    add_column :cards, :incorrect_answers, :string, array: true, default: []
  end
end
