class OauthCallbacksController < Devise::OmniauthCallbacksController

  def github
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Github') if navigational_format?
    else
      redirect_to root_path, alert: 'User does not exist'
    end
  end

  def vkontakte

  end
end
