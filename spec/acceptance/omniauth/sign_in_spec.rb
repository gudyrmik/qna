require 'rails_helper'

feature 'User can sign in with omniauth' do
  background { visit new_user_session_path }

  scenario 'via Github' do
    github_auth
    expect(page).to have_content 'Sign in with GitHub'

    click_on 'Sign in with GitHub'

    expect(page).to have_content('nickname@github.com')
    expect(page).to have_content("Sign Out")
  end

  scenario 'throuth Vkontakte' do
    vkontakte_auth
    expect(page).to have_content 'Sign in with Vkontakte'

    click_on 'Sign in with Vkontakte'
    fill_in 'Email', with: 'user@vk.com'
    click_on 'Confirm'
    open_email 'user@vk.com'
    current_email.click_link 'Confirm my account'

    expect(page).to have_content("user@vk.com")
    expect(page).to have_content("Sign Out")
  end
end
