class PlayersController < ApplicationController
  def create
    player = Player.new(player_params)
    if user_signed_in?
      player.creator = current_user
    else
      player.creator = User.anonymous
      player.creator_session_id = session.id
    end

    unless player.save
      return render json: { error: { player: player.errors.full_messages } },
                    status: :unprocessable_entity
    end

    @composition = get_composition
    unless @composition.persisted? || @composition.save
      return render json: { error: {
        composition: @composition.errors.full_messages
      } }, status: :unprocessable_entity
    end

    comp_player = CompositionPlayer.
      where(position: params[:position], composition_id: @composition).
      first_or_initialize
    comp_player.player = player

    unless comp_player.save
      return render json: { error: {
        composition_player: comp_player.errors.full_messages
      } }, status: :unprocessable_entity
    end

    @builder = CompositionFormBuilder.new(@composition)
    @available_players = @composition.available_players(user: current_user, session_id: session.id)

    render template: 'compositions/show'
  end

  private

  def player_params
    params.permit(:name, :battletag)
  end

  def get_composition
    if params[:composition_id]
      Composition.
        created_by(user: current_user, session_id: session.id).
        where(id: params[:composition_id]).first
    else
      comp = if user_signed_in?
        Composition.new(user: current_user)
      else
        Composition.new(user: User.anonymous, session_id: session.id)
      end
      comp.map_id = params[:map_id]
      comp
    end
  end
end
