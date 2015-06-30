require 'rails_helper'

describe 'Signing in' do

  context 'when user is not signed up' do

    it 'is not possible' do
      visit new_user_session_url
      within '#new_user' do
        fill_in 'user_email', with: ''
        fill_in 'user_password', with: ''
        click_button 'Log in'
      end
      expect(page).to have_content 'Invalid email or password.'
      expect(page).not_to have_link 'Log out'
    end

  end

  context 'when user is signed up' do

    before { @user = create :user, :donald }

    it 'is possible using email' do
      sign_in_with_donald
      expect(page).to have_content 'Signed in successfully.'
      expect(page).to have_link 'Log out'
    end

    # it 'is possible using name' do
    #   visit new_user_session_path
    #   within '#new_user' do
    #     fill_in 'user_email', with: 'donald@example.com'
    #     fill_in 'user_password', with: 's3cur3p@ssw0rd'
    #     click_button 'Log in'
    #   end
    #   expect(page).to have_content 'Signed in successfully.'
    #   expect(page).to have_link 'Log out'
    # end

    it 'is not possible with wrong email' do
      visit new_user_session_path
      within '#new_user' do
        fill_in 'user_email', with: 'unknown'
        fill_in 'user_password', with: 's3cur3p@ssw0rd'
        click_button 'Log in'
      end
      expect(page).to have_content 'Invalid email or password.'
      expect(page).not_to have_link 'Log out'
    end

    it 'is not possible with wrong password' do
      visit new_user_session_path
      within '#new_user' do
        fill_in 'user_email', with: 'donald'
        fill_in 'user_password', with: 'wrong'
        click_button 'Log in'
      end
      expect(page).to have_content 'Invalid email or password.'
      expect(page).not_to have_link 'Log out'
    end

  end

end
