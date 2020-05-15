require 'rails_helper'

RSpec.describe 'User', type: :feature do
  before(:all) do
    User.create(name: 'Sergio Zambrano', email: 'sergiomauz@mail.com', password: '123456')
    User.create(name: 'Felipe Rosa', email: 'felipe@mail.com', password: '123456')
    User.create(name: 'Selena Perez', email: 'selena@mail.com', password: '123456')
    User.create(name: 'Elvis Presley', email: 'elvis@mail.com', password: '123456')
    User.create(name: 'Heitor Nunes', email: 'heitor@mail.com', password: '123456')
    User.find(1).friendships.create(friend_id: 3, accepted: true)
    User.find(3).friendships.create(friend_id: 1, accepted: true)
    User.find(4).friendships.create(friend_id: 1, accepted: false)
    User.find(5).friendships.create(friend_id: 1, accepted: false)
  end

  context 'when logged in as Sergio' do
    before(:each) do
      visit new_user_session_path
      fill_in 'user_email', with: 'sergiomauz@mail.com'
      fill_in 'user_password', with: '123456'
      find("input[type='submit']").click
    end

    context 'when you are in -all users- page' do
      before(:each) do
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

      context 'when accepts a friendship request' do
        before(:each) { find('li', text: 'Heitor Nunes').click_link('(Accept friendship request)') }
        it 'gets a message "Friendship accepted!"' do
          expect(page).to have_content('Friendship accepted!')
        end

        it 'creates Heitor Nunes as a new entry in Sergio Zambrano friendships' do
          expect(User.find(1).friends.where(name: 'Heitor Nunes')[0]).to be_truthy
        end

        it 'creates Sergio Zambrano as a new entry in Heitor Nunes friendships' do
          expect(User.find(5).friends.where(name: 'Sergio Zambrano')[0]).to be_truthy
        end
      end
    end

    context 'when you are in -friends- page' do
      it 'accepts a friendship invitation' do
        visit friendships_path
        find('a', text: 'Elvis').find('+a').click
        expect(page).to have_content('Friendship accepted!')
      end
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
