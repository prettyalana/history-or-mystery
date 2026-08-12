class RoomsController < ApplicationController
  before_action :set_room, only: %i[ show ]
  # GET /rooms/1 or /rooms/1.json
  def show
  end

  # POST /rooms or /rooms.json
  def create
    @room = Room.new
    @room.code = SecureRandom.alphanumeric(4).upcase
    respond_to do |format|
      if @room.save
        player = @room.players.create!(
          name: params[:name],
          seat: "a",
        )
        cookies.encrypted[:auth_token] = player.token
        format.html { redirect_to @room, notice: "room was successfully created." }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :show, status: :unprocessable_entity }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  def join
    # Room lookup
    room = Room.find_by(code: params[:code])
    if room.nil?
      redirect_to root_path, alert: "this room does not exist"
      return
    end

    if room.players.count == 2
      redirect_to root_path, alert: "room is full"
      return
    end

    player = room.players.create!(
      name: params[:name],
      seat: "b",
    )
    cookies.encrypted[:auth_token] = player.token
    redirect_to room, notice: "you successfully joined room"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_room
    @room = Room.find_by!(code: params[:code])
  end
end
