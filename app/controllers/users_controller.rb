class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:update]

  def current
    if user_signed_in?
      @user = current_user
      render template: 'users/show'
    else
      render json: { user: { auth: false, battletag: nil } }
    end
  end

  def update
    attrs = {
      email: params[:email], region: params[:region].presence,
      platform: params[:platform].presence
    }

    if current_user.update_attributes(attrs)
      @user = current_user
      render template: 'users/show'
    else
      render json: { error: { user: current_user.errors } },
             status: :bad_request
    end
  end
end
