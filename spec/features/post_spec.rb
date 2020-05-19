require 'rails_helper'

$mauricios_post = 'Hello Augusto'
$augustos_post = 'Hello Mauricio'
$magic_post = 'Hello Rails'
RSpec.describe 'Post', type: :feature do  
  before(:all) do
    User.create(name: 'Mauricio Jove', email: 'mauricio@mail.com', password: '123456')
    User.create(name: 'Augusto Rosa', email: 'augusto@mail.com', password: '123456')
    User.create(name: 'Magic Johnson', email: 'magic@mail.com', password: '123456')        

    u1 = User.find_by(email: 'mauricio@mail.com')
    u2 = User.find_by(email: 'augusto@mail.com')
    u3 = User.find_by(email: 'magic@mail.com')

    u1.posts.create(content: $mauricios_post)
    u2.posts.create(content: $augustos_post)
    u3.posts.create(content: $magic_post)
    
    u1.friendships.create(friend_id: u2.id, accepted: true)
    u2.friendships.create(friend_id: u1.id, accepted: true)
  end

  before(:each) do
    visit new_user_session_path
    fill_in 'user_email', with: 'mauricio@mail.com'
    fill_in 'user_password', with: '123456'
    find("input[type='submit']").click        
  end

  it 'when -mauricio@mail.com- sign in, he can his posts' do
    expect(page).to have_content($mauricios_post)
  end

  it 'when -mauricio@mail.com- sign in, he can see the post of -augusto@mail.com-' do
    expect(page).to have_content($augustos_post)
  end

  it 'when -mauricio@mail.com- sign in, he can not see the post of -magic@mail.com-' do
    expect(page).to_not have_content($magic_post)
  end
end
