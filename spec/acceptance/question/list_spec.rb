require 'rails_helper'

feature 'Guest can see all asked questions', %q{
  In order to check, if my question was already asked,
  As an unauthenticated user,
  I'de like to be able to browse list of all questions
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user browses question list' do
    login(user)
    visit questions_path

    expect(page).to have_content 'MyString'
    expect(page).to have_content 'MyText'
    expect(page).to have_content question.author
  end

  scenario 'Unauthenticated user browses question list' do
    visit questions_path
    expect(page).to have_content 'MyString'
    expect(page).to have_content 'MyText'
    expect(page).to have_content question.author
  end
end