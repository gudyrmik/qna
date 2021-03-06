require 'rails_helper'

feature 'User is able to create an answer to a question', %q{
  In order to help community,
  As an authenticated user,
  I'de like to be able to answer a question,
  Directly from the question's page
} do
  given!(:user1) { create(:user) }
  given!(:user2) { create(:user) }
  given!(:question) { create(:question, user_id: user1.id) }

  describe 'Authenticated user' do
    background do
      login(user1)
      visit questions_path(question)
    end

    scenario 'creates correct answer', js: true do
      click_on question.title

      within ".new-answer" do
        fill_in 'Body', with: 'Answer text'
      end

      click_on 'Post answer'

      expect(page).to have_content 'Answer text'
    end

    scenario 'asks correct answer with attached file(s)', js: true do
      click_on question.title

      within ".new-answer" do
        fill_in 'Body', with: 'Answer text'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      end

      click_on 'Post answer'

      expect(page).to have_content 'Answer text'
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'creates invalid answer', js: true do
      click_on question.title
      click_on 'Post answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user attempts to answer a question' do
    visit questions_path(question)

    expect(page).to have_content 'Login'
  end

  scenario 'Answer appears on others user page', js: true do
    Capybara.using_session('other_user') do
      login(user2)
      visit questions_path(question)
    end

    Capybara.using_session('main_user') do
      login(user1)
      visit questions_path(question)

      click_on question.title

      within ".new-answer" do
        fill_in 'Body', with: 'Answer text'
      end

      click_on 'Post answer'

      expect(page).to have_content 'Answer text'
    end

    Capybara.using_session('other_user') do
      click_on question.title
      expect(page).to have_content 'Answer text'
    end
  end
end
