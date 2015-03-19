require 'rails_helper'

RSpec.describe Item do
  it 'is invalid without a title' do
    expect(FactoryGirl.build(:item, title: nil)).not_to be_valid
  end
end
