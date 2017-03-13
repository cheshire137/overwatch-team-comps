class CompositionsController < ApplicationController
  def last_composition
    @composition = Composition.last_saved(current_user, session.id) ||
      new_composition
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
    params.permit(:player_name, :composition_id, :hero_id, :map_segment_id,
                  :player_id, :player_position, :map_id)
  end

  def new_composition
    map = Map.first

    if user_signed_in?
      Composition.new(map: map, user: current_user)
    else
      Composition.new(map: map, user: User.anonymous, session_id: session.id)
    end
  end
end
