require 'rails_helper'

RSpec.describe Theme, type: :model do

  describe Theme do

    it "has a valid factory" do
      expect(FactoryGirl.create(:theme)).to be_valid
    end

    it "is invalid without a name"  do
      expect(FactoryGirl.build(:theme, name: nil)).not_to be_valid
    end

    it "is invalid with a description larger than 255 characters" do
      expect(FactoryGirl.build(:invalid_about_theme)).not_to be_valid
    end

  end


end
