class HomeController < ApplicationController
  before_action :check_room_code

  def show
  end

  private

  def check_room_code
    redirect_to Current.player.room if Current.player&.room
  end
end
