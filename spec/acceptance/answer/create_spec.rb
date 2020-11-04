require 'rails_helper'

feature 'User is able to create an answer to a question', %q{
  In order to help community,
  As an authenticated user,
  I'de like to be able to answer a question,
  Directly from the question's page
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user_id: user.id) }

  describe 'Authenticated user' do

    background do
      login(user)
      visit questions_path(question)
    end

    scenario 'creates correct answer', js: true do
      click_on 'MyString'

      fill_in 'Body', with: 'Answer text'
      click_on 'Post answer'

      expect(page).to have_content 'Answer text'
    end

    scenario 'asks correct answer with attached file(s)', js: true do
      click_on 'MyString'

      fill_in 'Body', with: 'Answer text'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Post answer'

      expect(page).to have_content 'Answer text'
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'creates invalid answer', js: true do
      click_on 'MyString'
      click_on 'Post answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user attempts to answer a question' do
    visit questions_path
    click_on 'MyString'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
