require 'rails_helper'

feature 'User can create a reward for question', %q{
  In order to say thanks to an author of the best answer
  As a question's author
  I'd like to be able to create a reward
} do

  given(:user) { create(:user) }

  scenario 'Author of question adds reward when asks question' do
    login(user)
    visit questions_path
    click_on 'Ask question'

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text'

    within '.reward' do
      fill_in 'Reward title', with: 'Reward'
      attach_file 'Image', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Ask'

    visit rewards_path

    expect(page).to have_content 'Reward'
  end
end
