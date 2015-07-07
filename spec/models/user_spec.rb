require 'rails_helper'

RSpec.describe User, type: :model do

  # it { should validate_presence_of(:name).with_message "can't be blank" }
  # it { should validate_uniqueness_of(:name).case_insensitive }
  it 'has a valid factory' do
    expect(FactoryGirl.create(:user)).to be_valid
  end

  describe 'creating a user' do

    # it 'validates presence of name' do
    #   @user = build :user, name: nil
    #   expect(@user).to have(1).error_on(:name)
    # end
    #
    # it 'validates uniqueness of name' do
    #   create :user, name: 'josh'
    #   @user = build :user, name: 'josh'
    #   expect(@user).to have(1).error_on(:name)
    # end

    it "is invalid without an email"  do
      expect(FactoryGirl.build(:user, email: nil)).not_to be_valid
    end

    # it 'validates presence of email' do
    #   @user = FactoryGirl.build(:user, email: nil)
    #   expect(@user).to have(1).error_on(:email)
    # end

    it "is invalid without a password"  do
      expect(FactoryGirl.build(:user, password: nil)).not_to be_valid
    end

    # it 'validates presence of password' do
    #   @user = factoryGirl.create(:user, password: nil)
    #   expect(@user).to have(1).error_on(:password)
    # end


  end

  it 'tells if the user has a specific role' do
    role = FactoryGirl.create(:role)
    role2 = FactoryGirl.create(:role)
    user = FactoryGirl.create(:user, roles: Role.where(name: role.name))
    expect(user.role?(role.name)).to be true
    expect(user.role?(role2.name)).to be false
  end

end
