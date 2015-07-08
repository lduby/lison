require 'rails_helper'

RSpec.describe Role, type: :model do

  it "is invalid with a description larger than 255 characters" do
    expect(FactoryGirl.build(:invalid_about_role)).not_to be_valid
  end

end
