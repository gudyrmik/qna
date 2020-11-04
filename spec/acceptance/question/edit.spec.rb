require 'rails_helper'

feature 'User can edit its question', %q{
  In order to add more information
  As an authenticated user
  I'de like to be able to edit my question
} do

  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      login(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'edits a question with attachmets', js: true do
      fill_in 'Title', with: 'Edited question'
      fill_in 'Body', with: 'Edited body'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'

      expect(page).to have_content 'Your question succsessfully created.'
      expect(page).to have_content 'Edited question'
      expect(page).to have_content 'Edited body'
    end
  end
end
