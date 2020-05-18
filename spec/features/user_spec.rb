require 'rails_helper'

RSpec.describe 'User', type: :feature do
  before(:all) do
    User.create(name: 'Sergio Zambrano', email: 'sergiomauz@mail.com', password: '123456')
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
