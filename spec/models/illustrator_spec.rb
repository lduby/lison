require 'rails_helper'

RSpec.describe Illustrator, type: :model do

  describe Illustrator do

    it "has a valid factory" do
      expect(FactoryGirl.create(:illustrator)).to be_valid
    end

    it "is invalid without a firstname"  do
      expect(FactoryGirl.build(:illustrator, firstname: nil)).not_to be_valid
    end

    it "is invalid without a lastname" do
      expect(FactoryGirl.build(:illustrator, lastname: nil)).not_to be_valid
    end

    it "is invalid with a description larger than 255 characters" do
      expect(FactoryGirl.build(:invalid_about_illustrator)).not_to be_valid
    end

    it "returns an illustrator's full name as a string" do
      illustrator = FactoryGirl.create(:illustrator, firstname: "John", lastname: "Doe")
      expect(illustrator.name).to eq "John Doe"
    end

  end

end
