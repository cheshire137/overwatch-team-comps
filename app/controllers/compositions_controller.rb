class CompositionsController < ApplicationController
  def new
    @composition = Composition.build_new(user: current_user, map: Map.first)
  end
end
