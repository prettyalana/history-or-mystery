class Player < ApplicationRecord
  belongs_to :room
  validates :name, :seat, :token, presence: true
end
