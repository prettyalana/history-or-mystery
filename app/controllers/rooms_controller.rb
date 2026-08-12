class RoomsController < ApplicationController
  before_action :set_room, only: %i[ show edit update destroy ]
  # before_action :ensure_current_user_is_buyer, only: [:destroy, :update, :edit]


  # GET /rooms/1 or /rooms/1.json
  def show
  end

  # POST /rooms or /rooms.json
  def create
    @room = Room.new(room_params)
    @room.code = Room.code

    respond_to do |format|
      if @room.save
        format.html { redirect_to @room, notice: "room was successfully created." }
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      @room = Room.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def room_params
      params.require(:room).permit()
    end
end
