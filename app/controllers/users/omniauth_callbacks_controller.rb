class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def bnet
    auth = request.env['omniauth.auth']
    user = User.where(provider: auth.provider, uid: auth.uid).first
    return sign_in_and_redirect(user, event: :authentication) if user

    session['devise.bnet_data'] = auth
    redirect_to users_finish_signup_path
  end

  def finish_signup
    @auth = session['devise.bnet_data']
  end

  def finished_signup
    @auth = session['devise.bnet_data']
    user = User.new(provider: @auth['provider'], uid: @auth['uid'],
                    email: params[:email],
                    battletag: @auth['info']['battletag'],
                    password: Devise.friendly_token[0,20])

    if user.save
      Player.where(creator_id: User.anonymous, creator_session_id: session.id).
             update_all(creator_id: user.id)
      Composition.where(user_id: User.anonymous, session_id: session.id).
                  update_all(user_id: user.id)

      session['devise.bnet_data'] = nil
      set_flash_message(:notice, :success, kind: "Battle.net")
      sign_in_and_redirect user, event: :authentication
    else
      flash[:alert] = 'Please provide an email address.'
      render :finish_signup
    end
  end

  def failure
    redirect_to root_path
  end
end
