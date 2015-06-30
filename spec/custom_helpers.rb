module Helpers
  def help
    :available
  end
  def sign_in_with_donald
    visit new_user_session_path
    within '#new_user' do
      fill_in 'user_email', with: 'donald@example.com'
      fill_in 'user_password', with: 's3cur3p@ssw0rd'
      click_button 'Log in'
    end
  end
end
