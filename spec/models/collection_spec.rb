require 'rails_helper'

RSpec.describe Collection, type: :model do

  describe Collection do

    it "has a valid factory" do
      expect(FactoryGirl.create(:collection)).to be_valid
    end

    it "is invalid without a name"  do
      expect(FactoryGirl.build(:collection, name: nil)).not_to be_valid
    end

    it "is invalid with a description larger than 255 characters" do
      expect(FactoryGirl.build(:invalid_about_collection)).not_to be_valid
    end

  end


end
