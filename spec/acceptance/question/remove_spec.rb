require 'rails_helper'

feature 'User can remove its question', %q{
  In order to clean my (potentially duplicated) question
  As au authenticated user
  I'de like to be able to remove it
} do
  given(:user) { create(:user) }
  given!(:others_question) { create(:question) }
  background { login(user) }

  scenario "Authenticated user removes it's question" do
    Question.create(title: 'Question 1', body: 'Body 1', author: user.email)
    visit questions_path
    click_on 'Delete Question 1'
    click_on 'Delete MyString'

    expect(page).not_to have_content 'Question 1'
    expect(page).not_to have_content 'Body 1'
    expect(page).to have_content 'MyString'
    expect(page).to have_content 'MyText'
  end

  scenario "Authenticated user attempts to remove other's question" do
    visit questions_path
    click_on 'Delete MyString'

    expect(page).to have_content 'MyString'
    expect(page).to have_content 'MyText'
  end

end