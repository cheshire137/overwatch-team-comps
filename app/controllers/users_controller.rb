class UsersController < ApplicationController
  def current
    if user_signed_in?
      render json: {
        auth: true,
        battletag: current_user.battletag,
        authenticityToken: form_authenticity_token,
        platform: current_user.platform,
        region: current_user.region
      }
    else
      render json: { auth: false, battletag: nil }
    end
  end
end
