require 'rails_helper'

describe 'Signing up' do
  it 'signs up a new user and lets him confirm his email' do
    visit new_user_registration_path
    # attach_file 'user_avatar', dummy_file_path('image.jpg')
    # fill_in 'user_name', with: 'newuser'
    fill_in 'user_email', with: 'newuser@example.com'
    fill_in 'user_password', with: 'somegreatpassword'
    fill_in 'user_password_confirmation', with: 'somegreatpassword'
    click_button 'Sign up'
    expect(page).to have_content 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'
    expect(unread_emails_for('newuser@example.com').size).to eq 1
    # expect(page).to have_link 'Log out'
    visit_in_email('Confirm my account', 'newuser@example.com')
    expect(page).to have_content 'Your email address has been successfully confirmed.'
    visit new_user_session_path
    within '#new_user' do
      fill_in 'user_email', with: 'newuser@example.com'
      fill_in 'user_password', with: 'somegreatpassword'
      click_button 'Log in'
    end
    expect(page).to have_content 'Signed in successfully.'
    expect(page).to have_link 'Log out'
  end
end
