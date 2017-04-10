# For returning a list of the available maps.
class MapsController < ApplicationController
  def index
    @maps = Map.includes(:segments).order(:name)

    compositions = Composition.where(map_id: @maps.pluck(:id)).
      created_by(user: current_user, session_id: session.id)

    @compositions_by_map = {}
    @maps.each { |map| @compositions_by_map[map.id] ||= [] }

    compositions.each do |composition|
      @compositions_by_map[composition.map_id] << composition
    end
  end
end
