require 'rails_helper'

describe "Collections to items relationship" do

  before(:all) do
    @avrail = FactoryGirl.create(:item, :title => 'Les Aventuriers du rail')
    @wonders = FactoryGirl.create(:item, :title => '7 Wonders')
    @dow = FactoryGirl.create(:collection, :name => 'Days of Wonder')
  end

  it "should recognise when a collection has no items" do
    expect(@dow.items.count).to eq 0
  end

  it "should handle a collection with an item" do
    @dow.items << @avrail
    expect(@dow.items.count).to eq 1
  end

  it "should automatically know an item's collection" do
    @dow.items << @avrail
    expect(@avrail.collection.name).to eq "Days of Wonder"
  end

end
