class Room < ApplicationRecord
  belongs_to :current_card, class_name: "Card", optional: true
  belongs_to :drawer_player, class_name: "Player", optional: true
  belongs_to :guesser_player, class_name: "Player", optional: true
  belongs_to :winner_player, class_name: "Player", optional: true
  has_many :players, dependent: :destroy

  def to_param
    code
  end
end
