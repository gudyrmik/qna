class OauthCallbacksController < Devise::OmniauthCallbacksController

  def github
    authenticate_with_provider('GitHub')
  end

  def vkontakte
    authenticate_with_provider('Vkontakte')
  end

  private

  def authenticate_with_provider(provider_name)
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider_name) if is_navigational_format?
    else
      redirect_to root_path, alert: "Something went wrong"
    end
  end
end
