require 'rails_helper'

RSpec.describe Publisher, type: :model do

  describe Publisher do

    it "has a valid factory" do
      expect(FactoryGirl.create(:publisher)).to be_valid
    end

    it "is invalid without a name"  do
      expect(FactoryGirl.build(:publisher, name: nil)).not_to be_valid
    end

    it "is invalid with a description larger than 255 characters" do
      expect(FactoryGirl.build(:invalid_about_publisher)).not_to be_valid
    end

  end


end
