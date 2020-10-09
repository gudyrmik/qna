require 'rails_helper'

feature 'User can remove its question', %q{
  In order to clean my (potentially duplicated) question
  As au authenticated user
  I'de like to be able to remove it
} do
  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given!(:others_question) { create(:question, user_id: user1.id) }
  background { login(user2) }

  scenario "Authenticated user removes it's question" do
    Question.create(title: 'Question', body: 'Body', user_id: user2.id)
    visit questions_path

    click_on 'Delete Question'

    expect(page).to_not have_content 'Question'
    expect(page).to_not have_content 'Delete MyString'
  end

  scenario "Authenticated user attempts to remove other's question" do
    visit questions_path

    expect(page).to_not have_content 'Delete MyString'
  end

end