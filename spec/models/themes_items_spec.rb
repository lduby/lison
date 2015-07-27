require 'rails_helper'

describe "Themes to items relationship" do

  before(:all) do
    @avrail = FactoryGirl.create(:item, :title => 'Les Aventuriers du rail')
    @wonders = FactoryGirl.create(:item, :title => '7 Wonders')
    @dow = FactoryGirl.create(:theme, :name => 'Building')
  end

  it "should recognise when a theme has no items" do
    expect(@dow.items.count).to eq 0
  end

  it "should handle a theme with an item" do
    @dow.items << @avrail
    expect(@dow.items.count).to eq 1
  end

  it "should automatically know an item's themes" do
    @dow.items << @avrail
    expect(@avrail.themes.last.name).to eq "Building"
  end

end
