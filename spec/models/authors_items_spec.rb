require 'rails_helper'

describe "Authors to items relationship" do

  before(:all) do
    @smashup = FactoryGirl.create(:item, :title => 'Smash Up')
    @wonders = FactoryGirl.create(:item, :title => '7 Wonders')
    @bcathala = FactoryGirl.create(:author, :firstname => 'Bruno', :lastname => 'Cathala')
    @abauza = FactoryGirl.create(:author, :firstname => 'Antoine', :lastname => 'Bauza')
  end

  it "should recognise when an author has no items" do
    expect(@bcathala.items.count).to eq 0
  end

  it "should handle an author with an item" do
    @bcathala.items << @smashup
    expect(@bcathala.items.count).to eq 1
  end

  it "should automatically know an item's author" do
    @bcathala.items << @smashup
    expect(@smashup.authors.count).to eq 1
  end

  it "should hanlde an author collaboration" do
    @bcathala.items << @smashup
    @abauza.items << @smashup
    expect(@smashup.authors.count).to eq 2
  end

end
