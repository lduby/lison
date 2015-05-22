require 'rails_helper'

describe "Publishers to collections relationship" do

  before(:all) do
    @avrail = FactoryGirl.create(:collection, :name => 'Les Aventuriers')
    @wonders = FactoryGirl.create(:collection, :name => 'Merveilles')
    @dow = FactoryGirl.create(:publisher, :name => 'Days of Wonder')
  end

  it "should recognise when a publisher has no collection" do
    expect(@dow.items.count).to eq 0
  end

  it "should handle a publisher with a collection" do
    @dow.collections << @avrail
    expect(@dow.collections.count).to eq 1
  end

  it "should automatically know a collection's publisher" do
    @dow.collections << @avrail
    expect(@avrail.publisher.name).to eq "Days of Wonder"
  end

end
