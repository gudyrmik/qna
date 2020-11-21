require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As a question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:link) { 'https://www.google.com/' }

  scenario 'User adds link when asks question' do
    login(user)
    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text'

    fill_in 'Link name', with: 'Google'
    fill_in 'Url', with: link

    click_on 'Ask'

    expect(page).to have_link 'Google', href: link
  end

end
