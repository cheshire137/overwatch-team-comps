class HomeController < ApplicationController
  def index
    @user = current_user || User.new
  end
end
