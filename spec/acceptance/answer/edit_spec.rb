require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  given!(:user2) { create(:user) }
  given!(:question2) { create(:question, user: user2) }
  given!(:answer2) { create(:answer, question: question2, user: user2) }

  scenario 'Unauthenticated user can not edit answers' do
    visit question_path(question)
    expect(page).to_not have_link('Edit')
  end

  describe 'Authenticated user do legit action' do

    background do
      login(user)
      visit question_path(question)

      click_on('Edit')
    end

    scenario 'edits his answer', js: true do
      within '.answers' do
        fill_in 'Your answer', with: 'Edited answer'
        click_on('Save')
        expect(page).to_not have_content(answer.body)
        expect(page).to have_content('Edited answer')
        expect(page).to_not have_selector('textarea')
      end
    end

    scenario 'edits his answer with errors', js: true do
      within '.answers' do
        fill_in 'Your answer', with: nil
        click_on('Save')
      end
      expect(page).to have_content("Body can't be blank")
    end

    scenario 'edits his answer with attachments', js: true do
      within '.answers' do
        fill_in 'Your answer', with: 'Edited answer'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        click_on('Save')

        expect(page).to have_content('Edited answer')
        expect(page).to_not have_selector('textarea')
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end

  describe 'Authenticated user tries' do
    scenario "to edit other user's answer", js: true do
      login(user)
      visit question_path(question2)
      expect(page).to_not have_link('Edit')
    end
  end
end
