require 'rails_helper'

describe 'Canceling account' do
  before do
    @user = create :user, :donald
    sign_in_with_donald
  end
  it 'cancels the account' do
    visit root_path
    click_link 'Edit'
    click_button 'Cancel my account'
    expect(page).to have_content 'Bye! Your account has been successfully cancelled. We hope to see you again soon.'
  end
end
