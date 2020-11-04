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

    scenario 'asks a question with attached file(s)' do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user attempts to ask a question' do
    visit questions_path

    expect(page).to_not have_content 'Ask question'
  end
end
