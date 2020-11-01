require 'rails_helper'

feature 'User is able to create an answer to a question', %q{
  In order to help community,
  As an authenticated user,
  I'de like to be able to answer a question,
  Directly from the question's page
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user_id: user.id) }

  scenario 'Authenticated user creates correct answer', js: true do
    login(user)
    visit questions_path(question)

    click_on 'MyString'

    fill_in 'Body', with: 'Answer text'
    click_on 'Post answer'

    save_and_open_page
    expect(page).to have_content 'Answer text'
  end

  scenario 'Authenticated user creates invalid answer', js: true do
    login(user)
    visit questions_path(question)

    click_on 'MyString'
    click_on 'Post answer'
    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Unauthenticated user attempts to answer a question' do
    visit questions_path
    click_on 'MyString'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
