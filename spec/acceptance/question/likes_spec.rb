require 'rails_helper'

feature 'User can like a question', %q{
  In order to make question's author happy
  As an authenticated user
  I'd like to be able to set a like
} do

  given(:user) { create(:user) }
  given(:liker) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'User ', js: true do

    background do
      login(liker)
      visit questions_path
    end

    scenario 'likes question' do
      click_on 'MyString'
      click_on '+'

      within '.rating' do
        save_and_open_page
        expect(page).to have_content '1'
      end
    end
  end
end
