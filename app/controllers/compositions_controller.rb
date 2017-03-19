class CompositionsController < ApplicationController
  def show
    @composition = Composition.friendly.find(params[:slug])
    @builder = CompositionFormBuilder.new(@composition)
    @available_players = []
  end

  def last_composition
    @composition = most_recent_composition || new_composition
    @builder = CompositionFormBuilder.new(@composition)
    @available_players = @composition.available_players(user: current_user, session_id: session.id)

    render template: 'compositions/show'
  end

  def save
    saver = CompositionSaver.new(user: current_user, session_id: session.id)

    success = begin
      saver.save(composition_params)
    rescue CompositionSaver::Error => ex
      return render json: { error: ex.message }, status: :bad_request
    end

    unless success
      return render json: {
        error: {
          saver.error_type => saver.error_value.full_messages
        }
      }, status: :unprocessable_entity
    end

    @composition = saver.composition
    @builder = CompositionFormBuilder.new(@composition)
    @available_players = @composition.available_players(user: current_user, session_id: session.id)

    render template: 'compositions/show'
  end

  private

  def composition_params
    params.permit(:composition_id, :hero_id, :map_segment_id, :player_id,
                  :player_position, :map_id)
  end

  def most_recent_composition
    scope = Composition.most_recent(user: current_user, session_id: session.id)
    scope = scope.where(map_id: params[:map_id]) if params[:map_id]
    scope.first
  end

  def new_composition
    map = if params[:map_id]
      Map.find(params[:map_id])
    else
      Map.first
    end

    if user_signed_in?
      Composition.new(map: map, user: current_user)
    else
      Composition.new(map: map, user: User.anonymous, session_id: session.id)
    end
  end
end
