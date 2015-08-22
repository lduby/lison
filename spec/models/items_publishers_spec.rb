require 'rails_helper'

describe "Publishers to items relationship" do

  before(:all) do
    DatabaseCleaner.clean
    @avrail = FactoryGirl.create(:item)
    @wonders = FactoryGirl.create(:item)
    @dow = FactoryGirl.create(:publisher)
  end

  it "should recognise when a publisher has no items" do
    expect(@dow.items.count).to eq 0
  end

  it "should handle a publisher with an item" do
    @dow.items << @avrail
    expect(@dow.items.count).to eq 1
  end

  it "should automatically know an item's publisher" do
    @dow.items << @avrail
    expect(@avrail.publisher.name).to eq @dow.name
  end

end
