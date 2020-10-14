require 'rails_helper'

feature 'User can remove its answer', %q{
  In order to clean my (potentially worse) answer
  As au authenticated user
  I'de like to be able to remove it
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  given!(:user2) { create(:user) }
  given!(:question2) { create(:question, user: user2) }
  given!(:answer2) { create(:answer, question: question2, user: user2) }

  scenario "Authenticated user removes it's answer", js: true do
    login(user)
    visit question_path(question)

    click_on 'Delete'

    expect(page).to_not have_link('Edit')
  end

  scenario "Authenticated user attempts to remove other's answer", js: true do
    login(user)
    visit question_path(question2)
    expect(page).to_not have_link('Delete')
  end
end
