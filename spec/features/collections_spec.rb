require 'rails_helper'

describe "Collections" do

  describe "Manage collections" do

    it "Adds a new collection and displays the results" do
      visit collections_url
      expect{
        click_link 'New collection'
        fill_in 'Name', with: "Iello"
        click_button "Save Collection"
      }.to change(Collection,:count).by(1)
      within 'h1' do
        expect(page).to have_content "Iello"
      end
    end

    it "Shows a collection details" do
      collection = FactoryGirl.create(:collection, name: "Iello")
      visit collections_url
      expect{
        click_link "show_collection_#{collection.id}"
      }.to_not change(Collection,:count)
      within 'h1' do
        expect(page).to have_content "Iello"
      end
    end

    it "Shows a collection details from an item details" do
      collection = FactoryGirl.create(:collection, name: "Iello")
      item = FactoryGirl.create(:item, title: "Wazabi", collection_id: collection.id)
      visit items_url
      click_link "show_item_#{item.id}"
      within 'h1' do
        expect(page).to have_content "Wazabi"
      end
      click_link "show_collection_#{collection.id}"
      within 'h1' do
        expect(page).to have_content "Iello"
      end

    end

    it "Shows a collection items" do
      collection = FactoryGirl.create(:collection, name: "Iello")
      item = FactoryGirl.create(:item, title: "Wazabi", collection_id: collection.id)
      item2 = FactoryGirl.create(:item, title: "Hanabi")
      visit collections_url
      click_link "show_items_of_collection_#{collection.id}"
      within 'h1' do
        expect(page).to have_content "Iello items"
      end
      expect(page).to have_content "Wazabi"
      expect(page).to_not have_content "Hanabi"
    end

    it "Updates a collection and displays the results" do
      collection = FactoryGirl.create(:collection, name: "Iello")
      visit collections_url
      expect{
        click_link "edit_collection_#{collection.id}"
        fill_in 'Name', with: "Days of Wonder"
        click_button "Save Collection"
      }.to_not change(Collection,:count)
      within 'h1' do
        expect(page).to have_content "Days of Wonder"
      end
    end

    it "Deletes a collection" do
      collection = FactoryGirl.create(:collection, name: "Iello")
      visit collections_path
      expect{
          click_link "del_collection_#{collection.id}"
      }.to change(Collection,:count).by(-1)
      expect(page).to have_content "All collections"
      expect(page).to_not have_content "Iello"
    end

    it "Deletes an collection with js dialog", js: true do
      DatabaseCleaner.clean
      collection = FactoryGirl.create(:collection, name: "Iello")
      visit collections_path
      sleep 1
      expect{
          click_link "del_collection_#{collection.id}"
          sleep 1
          alert = page.driver.browser.switch_to.alert
          alert.accept
          sleep 1
      }.to change(Collection,:count).by(-1)
      expect(page).to have_content "All collections"
      expect(page).to_not have_content "Iello"
    end

  end

end
