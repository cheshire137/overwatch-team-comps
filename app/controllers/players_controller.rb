class PlayersController < ApplicationController
  before_filter :require_composition

  def create
    @player = Player.new(player_params)
    if user_signed_in?
      @player.creator = current_user
    else
      @player.creator = User.anonymous
      @player.creator_session_id = session.id
    end

    unless @player.save
      return render json: { error: { player: @player.errors.full_messages } },
                    status: :unprocessable_entity
    end

    @comp_player = CompositionPlayer.
      where(position: params[:position], composition_id: composition).
      first_or_initialize
    @comp_player = @player

    unless @comp_player.save
      return render json: { error: {
        composition_player: @comp_player.errors.full_messages
      } }, status: :unprocessable_entity
    end
  end

  private

  def player_params
    params.permit(:name, :battletag)
  end

  def require_composition
    head :not_found unless composition
  end

  def composition
    Composition.
      created_by(user: current_user, session_id: session.id).
      where(id: params[:composition_id]).first
  end
end
