require 'rails_helper'

describe "Illustrators to items relationship" do

  before(:all) do
    @smashup = FactoryGirl.create(:item, :title => 'Smash Up')
    @wonders = FactoryGirl.create(:item, :title => '7 Wonders')
    @bcathala = FactoryGirl.create(:illustrator, :firstname => 'Bruno', :lastname => 'Cathala')
    @abauza = FactoryGirl.create(:illustrator, :firstname => 'Antoine', :lastname => 'Bauza')
  end

  it "should recognise when an illustrator has no items" do
    expect(@bcathala.items.count).to eq 0
  end

  it "should handle an illustrator with an item" do
    @bcathala.items << @smashup
    expect(@bcathala.items.count).to eq 1
  end

  it "should automatically know an item's illustrator" do
    @bcathala.items << @smashup
    expect(@smashup.illustrators.count).to eq 1
  end

  it "should hanlde an illustrator collaboration" do
    @bcathala.items << @smashup
    @abauza.items << @smashup
    expect(@smashup.illustrators.count).to eq 2
  end

end
