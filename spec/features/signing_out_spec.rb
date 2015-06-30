require 'rails_helper'

describe 'Signing out' do

  before do
    @user = create :user, :donald
  end

  it 'signs the user out' do
    sign_in_with_donald
    visit items_url
    click_link "Log out"
    expect(page).to have_content 'Signed out successfully.'
    expect(page).not_to have_link 'Login'
  end

end
