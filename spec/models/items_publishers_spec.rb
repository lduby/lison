require 'rails_helper'

describe "Publishers to items relationship" do

  before(:all) do
    @avrail = FactoryGirl.create(:item, :title => 'Les Aventuriers du rail')
    @wonders = FactoryGirl.create(:item, :title => '7 Wonders')
    @dow = FactoryGirl.create(:publisher, :name => 'Days of Wonder')
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
    expect(@avrail.publisher.name).to eq "Days of Wonder"
  end

end
