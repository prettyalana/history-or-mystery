class RoomsController < ApplicationController
  before_action :set_room, only: %i[ show start_round submit_clue resolve_round ]
  # GET /rooms/1 or /rooms/1.json
  def show
    # If the game is done clear browser cookies
    if @room.round_status == "finished"
      cookies.delete(:auth_token)
    end
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
        format.html { redirect_to @room, notice: "Room #{@room.code} was successfully created." }
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
      redirect_to root_path, alert: "This room does not exist"
      return
    end

    if room.players.count == 2
      redirect_to root_path, alert: "The room is full"
      return
    end

    player = room.players.create!(
      name: params[:name],
      seat: "b",
    )
    cookies.encrypted[:auth_token] = player.token
    redirect_to room, notice: "You successfully joined room #{@room.code}"
  end

  def start_round

    if @room.round_number >= 3
      @room.update(
        round_status: "finished"
      )
      redirect_to @room
      return

      # Display Game complete, the score, and a link to the main menu to start a new game
    end

    random_card = Card.where.not(id: @room.used_card_ids).sample

    if @room.drawer_player.nil?
      drawer_player, guesser_player = @room.players.shuffle
    else
      drawer_player = @room.drawer_player
      guesser_player = @room.guesser_player
    end

    @room.update!(
      drawer_player: drawer_player,
      guesser_player: guesser_player,
      current_card_id: random_card.id,
      used_card_ids: @room.used_card_ids + [random_card.id],
      round_number: @room.round_number + 1,
      round_started_at: Time.current,
      round_status: "active",
      clue_text: nil,
    )

    redirect_to @room
  end

  def submit_clue
    if Current.player == @room.drawer_player
      @room.update(
        clue_text: params[:clue]
      )
    end
    redirect_to @room
  end

  def resolve_round
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_room
    @room = Room.find_by!(code: params[:code])
  end
end
