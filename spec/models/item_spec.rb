require 'rails_helper'

RSpec.describe Item do

  it "has a valid factory" do
    expect(FactoryGirl.create(:item)).to be_valid
  end

  it 'is invalid without a title' do
    expect(FactoryGirl.build(:item, title: nil)).not_to be_valid
  end
end
