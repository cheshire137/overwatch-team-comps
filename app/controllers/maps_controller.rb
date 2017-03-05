class MapsController < ApplicationController
  def index
    @maps = Map.order(:name)
  end
end
