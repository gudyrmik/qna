require 'rails_helper'

feature 'User can see question and answers to it', %q{
  In order to find good answer,
  As an authenticated user
  I'de like to be able to see question and all it's answers
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user_id: user.id) }

  scenario 'Authenticated user opens a question' do
    login(user)
    visit questions_path
    click_on 'MyString'
    expect(page).to have_content 'MyString'
  end

  scenario 'Unauthenticated user attempts to open a question' do
    visit questions_path
    click_on 'MyString'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end