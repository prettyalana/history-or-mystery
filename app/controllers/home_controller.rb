class HomeController < ApplicationController
  skip_before_action :authenticate, only: [ :show ]

  def show
    @active_room = Current.player&.room
    if @active_room && (@active_room.round_status == "finished" || @active_room.round_status == "forfeited" || @active_room.round_status == "won")
      cookies.delete(:auth_token)
      @active_room = nil
    end
  end

  private

  def check_room_code
    redirect_to Current.player.room if Current.player&.room
  end
end
