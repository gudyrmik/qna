require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As a question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:link) { 'https://www.pornhub.com/' }

  scenario 'User adds link when asks question', js: true do
    login(user)
    visit questions_path

    click_on 'Ask question'

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Which site is the best?'

    click_on 'Add link'

    fill_in 'Link name', with: 'Pornhub'
    fill_in 'Url', with: link

    click_on 'Ask'
    expect(page).to have_link 'Pornhub', href: link
  end

end

