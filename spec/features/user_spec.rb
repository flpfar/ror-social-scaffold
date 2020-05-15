require 'rails_helper'

RSpec.describe 'User', type: :feature do
  before(:all) do
    User.create(name: 'Sergio Zambrano', email: 'sergiomauz@mail.com', password: '123456')
    User.create(name: 'Felipe Rosa', email: 'felipe@mail.com', password: '123456')
    User.create(name: 'Selena Perez', email: 'selena@mail.com', password: '123456')
    User.create(name: 'Elvis Presley', email: 'elvis@mail.com', password: '123456')
    User.first.friendships.create(friend_id: 3, accepted: true)
  end

  context 'when logged in and in -all users- page' do
    before(:each) do
      visit new_user_session_path
      fill_in 'user_email', with: 'sergiomauz@mail.com'
      fill_in 'user_password', with: '123456'
      find("input[type='submit']").click
      visit users_path
    end
    it 'sends an invitation to a new friend' do
      find('li', text: 'Felipe').click_link('Send an invitation')
      expect(page).to have_content('Invitation sent')
    end
    it 'removes a friend' do
      find('li', text: 'Selena').click_link('Remove friend')
      expect(page).to have_content('Friendship removed')
    end
  end

  it 'is not a valid sign up if the email exists in the database' do
    visit new_user_registration_path
    fill_in 'user_name', with: 'Sergio Zambrano'
    fill_in 'user_email', with: 'sergiomauz@mail.com'
    fill_in 'user_password', with: '123456'
    fill_in 'user_password_confirmation', with: '123456'

    find("input[type='submit']").click

    expect(page).not_to have_content('Welcome! You have signed up successfully.')
  end

  it 'is valid sign up if redirected page have a welcome message' do
    visit new_user_registration_path
    fill_in 'user_name', with: 'Selene Perez'
    fill_in 'user_email', with: 'selene@tmail.com'
    fill_in 'user_password', with: '123456'
    fill_in 'user_password_confirmation', with: '123456'

    find("input[type='submit']").click

    expect(page).to have_content('Welcome! You have signed up successfully.')
  end
end
