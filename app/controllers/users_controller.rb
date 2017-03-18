class UsersController < ApplicationController
  def current
    if user_signed_in?
      render json: { auth: true, battletag: current_user.battletag }
    else
      render json: { auth: false, battletag: nil }
    end
  end
end
