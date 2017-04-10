# For viewing and updating the currently authenticated user.
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
    if current_user.update_attributes(user_attrs)
      @user = current_user
      render template: 'users/show'
    else
      render json: { error: { user: current_user.errors } },
             status: :bad_request
    end
  end

  private

  def user_attrs
    {
      email: params[:email], region: params[:region].presence,
      platform: params[:platform].presence
    }
  end
end
