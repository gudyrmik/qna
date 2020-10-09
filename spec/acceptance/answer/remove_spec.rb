require 'rails_helper'

feature 'User can remove its answer', %q{
  In order to clean my (potentially worse) answer
  As au authenticated user
  I'de like to be able to remove it
} do
  given(:user1) { create(:user) }
  given(:user2) { create(:user) }

  scenario "Authenticated user removes it's answer" do
    login(user1)
    Question.create(title: 'Question 1', body: 'Body 1', user_id: user1.id)
    visit questions_path
    click_on 'Question 1'

    fill_in 'Body', with: 'answer'
    click_on 'Post answer'

    click_on 'Delete answer'
    expect(page).not_to have_content 'answer'
  end

  scenario "Authenticated user attempts to remove other's answer" do
    login(user1)
    question = Question.create(title: 'Question 1', body: 'Body 1', user_id: user2.id)
    Answer.create(question_id: question.id, body: 'others answer', user_id: user2.id)
    visit questions_path
    click_on 'Question 1'
    expect(page).to_not have_content 'Delete others answer'
  end
end
