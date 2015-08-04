require 'rails_helper'

RSpec.describe Category, type: :model do

  describe Category do

    it "has a valid factory" do
      expect(FactoryGirl.create(:category)).to be_valid
    end

    it "is invalid without a name"  do
      expect(FactoryGirl.build(:category, name: nil)).not_to be_valid
    end

    it "is invalid with a description larger than 255 characters" do
      expect(FactoryGirl.build(:invalid_about_category)).not_to be_valid
    end

  end


end
