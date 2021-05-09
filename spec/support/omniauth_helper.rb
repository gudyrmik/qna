module ControllerHelpers
  def github_auth
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      provider: 'github',
      uid: '11',
      info: { nickname: 'nickname', email: 'name@github.com' }
    )
  end

  def vkontakte_auth
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new(
      provider: 'vkontakte',
      uid: '12',
      'info' => { email: nil }
    )
  end
end
