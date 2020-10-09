require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask question
  As an unauthenticated user
  I'd like to be able to sign in
} do
  given(:user) { create(:user) }
  background { visit new_user_session_path }

  scenario 'Registered user tries to sign in' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistered user tries to sign in' do
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password'
  end
end

feature 'User can sign out', %q{
  In order to finish user session
  As an authenticated user I'de like
  to be able to logout
  } do
  given(:user) { create(:user) }

  scenario 'Authorized user tries to sign out' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    click_on 'Log out'
    expect(page).to have_content 'Signed out successfully.'
  end
end

feature 'Guest can register', %q{
    In order to ask question
    As a guest (user without an account)
    I'd like to be able to register
  } do
  scenario 'Registered (existent) user tries to register' do
    user = create(:user)
    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password

    click_on 'Sign up'
    expect(page).to have_content 'Email has already been taken'
  end

  scenario 'Unregistered user tries to register' do
    visit new_user_registration_path
    fill_in 'Email', with: 'unregistered@qna.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'

    click_on 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end
