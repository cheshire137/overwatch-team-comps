class MapsController < ApplicationController
  def index
    @maps = Map.includes(:segments).order(:name)
  end
end
