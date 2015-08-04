require 'rails_helper'

describe "Categories to items relationship" do

  before(:all) do
    @avrail = FactoryGirl.create(:item, :title => 'Les Aventuriers du rail')
    @wonders = FactoryGirl.create(:item, :title => '7 Wonders')
    @dow = FactoryGirl.create(:category, :name => 'Expert')
  end

  it "should recognise when a category has no items" do
    expect(@dow.items.count).to eq 0
  end

  it "should handle a category with an item" do
    @dow.items << @avrail
    expect(@dow.items.count).to eq 1
  end

  it "should automatically know an item's categorys" do
    @dow.items << @avrail
    expect(@avrail.categories.last.name).to eq "Expert"
  end

end
