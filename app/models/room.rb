class Room < ApplicationRecord
  belongs_to :current_card, optional: true
  belongs_to :drawer_player, class_name: "Player", optional: true
  belongs_to :guesser_player, class_name: "Player", optional: true
  has_many :players, dependent: :destroy

  def to_param
    code
  end
end
