require 'rails_helper'

feature 'User can remove its answer', %q{
  In order to clean my (potentially worse) answer
  As au authenticated user
  I'de like to be able to remove it
} do
  given(:user) { create(:user) }

  scenario "Authenticated user removes it's answer" do
    login(user)
    Question.create(title: 'Question 1', body: 'Body 1', author: user.email)
    visit questions_path
    click_on 'Question 1'

    fill_in 'Body', with: 'answer'
    click_on 'Post answer'

    click_on 'Delete answer'
    expect(page).not_to have_content 'answer'
  end

  scenario "Authenticated user attempts to remove other's answer" do
    login(user)
    question = Question.create(title: 'Question 1', body: 'Body 1', author: user.email)
    Answer.create(question_id: question.id, body: 'others answer', author: 'others@qna.com')
    visit questions_path
    click_on 'Question 1'
    click_on 'Delete others answer'

    expect(page).to have_content 'others answer'
  end
end