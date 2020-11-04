require 'rails_helper'

feature 'Author of a question can choose best answer', %q{
  In order to better organise answers
  As an author of a question
  I'd like to be able to choose best answer, which will displayed first
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, title: 'Question 1', user: user) }
  given!(:answer1) { create(:answer, question: question, body: 'Answer 1', user: user) }
  given!(:answer2) { create(:answer, question: question, body: 'Answer 2', user: user) }

  scenario 'Author of a question selects best answer' do
    login(user)

    visit questions_path(question)
    click_on 'Question 1'

    within ".answer_#{answer2.id}" do
      click_on 'Mark as best'
    end

    within ".answer_#{answer2.id}" do
      expect(page).to have_content 'Answer 2'
    end

    within ".answer_#{answer1.id}" do
      expect(page).to have_content 'Answer 1'
    end
  end
end
