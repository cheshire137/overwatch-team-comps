class UsersController < ApplicationController
  def current
    if user_signed_in?
      render json: {
        auth: true, user: { battletag: current_user.battletag }
      }
    else
      render json: { auth: false }
    end
  end
end
