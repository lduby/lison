require 'rails_helper'

RSpec.describe Author, type: :model do

  describe Author do

    it "has a valid factory" do
      expect(FactoryGirl.create(:author)).to be_valid
    end

    it "is invalid without a firstname"  do
      expect(FactoryGirl.build(:author, firstname: nil)).not_to be_valid
    end

    it "is invalid without a lastname" do
      expect(FactoryGirl.build(:author, lastname: nil)).not_to be_valid
    end

    it "is invalid with a description larger than 255 characters" do
      expect(FactoryGirl.build(:invalid_about_author)).not_to be_valid
    end

    it "returns an author's full name as a string" do
      author = FactoryGirl.create(:author, firstname: "John", lastname: "Doe")
      expect(author.name).to eq "John Doe"
    end

  end

end
