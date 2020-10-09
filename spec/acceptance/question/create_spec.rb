require 'rails_helper'

feature 'User can create question', %q{
  In order to get an answer from community
  As an authenticated user
  I'de like to be able to ask a question
} do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      login(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text'
      click_on 'Ask'

      expect(page).to have_content 'Your question succsessfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthenticated user attempts to ask a question' do
    visit questions_path

    expect(page).to_not have_content 'Ask question'
  end
end