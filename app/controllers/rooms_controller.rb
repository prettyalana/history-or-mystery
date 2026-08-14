class RoomsController < ApplicationController
  before_action :set_room, only: %i[ show start_round request_clue submit_clue resolve_round ]
  skip_before_action :authenticate, only: [ :create, :join ]
  # GET /rooms/1 or /rooms/1.json
  def show
    # If the game is done clear browser cookies
    if @room.round_status == "finished" || @room.round_status == "forfeited" || @room.round_status == "won"
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
    broadcast_room_update(room)
    redirect_to room, notice: "You successfully joined room #{room.code}"
  end

  def start_round
    flash[:notice] = "Game started"

    if Current.player.seat == "a"
      game_play
      broadcast_room_update(@room)
      redirect_to @room
    else
      redirect_to @room, alert: "Only the room's creator can start the game"
    end
  end

  def request_clue
    if Current.player == @room.guesser_player
      @room.update(
        clue_revealed: true,
      )
    end
    broadcast_room_update(@room)
    redirect_to @room
  end

  def submit_clue
    if @room.clue_text.present?
      broadcast_room_update(@room)
      redirect_to @room, alert: "You can only submit one clue per round"
      return
    end

    if Current.player == @room.drawer_player && @room.clue_revealed == true
      @room.update(
        clue_text: params[:clue],
      )
    end
    broadcast_room_update(@room)
    redirect_to @room
  end

  def resolve_round
    if params[:outcome] == "won" && Current.player == @room.drawer_player
      flash[:notice] = "You won this round!"
      player_score = @room.guesser_player.score += 1
      @room.guesser_player.update(
        score: player_score,
      )
      if @room.round_number >= 3
        flash[:notice] = "You win! Game over."
        @room.update(
          round_status: "won",
        )
      else
        flash[:notice] = "You win!"
        game_play
      end
    elsif (params[:outcome] == "forfeit" && Current.player == @room.guesser_player) || (params[:outcome] == "incorrect" && Current.player == @room.drawer_player)
      flash[:notice] = "You lost this round"
      if @room.round_number >= 3
        flash[:notice] = "Game over."
        @room.update(
          round_status: "forfeited",
        )
      else
        flash[:notice] = params[:outcome] == "forfeit" ? "You forfeited" : "Incorrect"
        game_play
      end
    end
    broadcast_room_update(@room)
    redirect_to @room
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_room
    @room = Room.find_by!(code: params[:code])
  end

  def game_play
    if @room.round_number >= 3
      @room.update(
        round_status: "finished",
      )
      return
    end

    random_card = Card.where.not(id: @room.used_card_ids).sample

    if @room.drawer_player.nil?
      drawer_player, guesser_player = @room.players.shuffle
    else
      drawer_player = @room.guesser_player
      guesser_player = @room.drawer_player
    end

    @room.update!(
      drawer_player: drawer_player,
      guesser_player: guesser_player,
      current_card_id: random_card.id,
      used_card_ids: @room.used_card_ids +  [ random_card.id ],
      round_number: @room.round_number + 1,
      round_started_at: Time.current,
      round_status: "active",
      clue_text: nil,
      clue_revealed: false,
    )
  end

  def broadcast_room_update(room)
    room.players.each do |player|
      Turbo::StreamsChannel.broadcast_replace_to(
        "room_#{room.code}_seat_#{player.seat}",
        target: "room-content",
        partial: "rooms/gameplay",
        locals: { room: room, viewer: player },
      )
    end
  end
end
