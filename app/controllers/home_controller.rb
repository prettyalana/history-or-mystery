class HomeController < ApplicationController
  def show
    @active_room = Current.player&.room
  end

  private

  def check_room_code
    redirect_to Current.player.room if Current.player&.room
  end
end
