class Player < ApplicationRecord
  belongs_to :room
  validates :name, :seat, :token, presence: true
  has_secure_token
  has_secure_token :token, length: 36
end
