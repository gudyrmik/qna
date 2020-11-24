require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user_id: user.id) }
  given(:link) { 'https://www.google.com/' }

  scenario 'User adds link when give an answer', js: true do
    login(user)

    visit questions_path(question)

    click_on 'MyString'

    fill_in 'Body', with: 'Answer text'

    click_on 'Add link'

    fill_in 'Link name', with: 'Pornhub'
    fill_in 'Url', with: link

    fill_in 'Link name', with: 'Google'
    fill_in 'Url', with: link
    click_on 'Post answer'

    within '.answers' do
      expect(page).to have_link 'Google', href: link
    end
  end

end
