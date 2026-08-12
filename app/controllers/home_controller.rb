class HomeController < ApplicationController

  # This would instead be check for the room code
  before_action :check_room_code
  # If the user provided a room code redirect them to the room
  def check_room_code
    redirect_to room if room_code?
  end

end
