require 'rails_helper'

describe "Publishers" do

  describe "Manage publishers" do

    it "Adds a new publisher and displays the results" do
      visit publishers_url
      expect{
        click_link 'New publisher'
        fill_in 'Name', with: "Iello"
        click_button "Save Publisher"
      }.to change(Publisher,:count).by(1)
      within 'h1' do
        expect(page).to have_content "Iello"
      end
    end

    it "Shows a publisher details" do
      publisher = FactoryGirl.create(:publisher, name: "Iello")
      visit publishers_url
      expect{
        click_link "show_publisher_#{publisher.id}"
      }.to_not change(Publisher,:count)
      within 'h1' do
        expect(page).to have_content "Iello"
      end
    end

    it "Shows a publisher details from an item details" do
      publisher = FactoryGirl.create(:publisher, name: "Iello")
      item = FactoryGirl.create(:item, title: "Wazabi", publisher_id: publisher.id)
      visit items_url
      click_link "show_item_#{item.id}"
      within 'h1' do
        expect(page).to have_content "Wazabi"
      end
      click_link "show_publisher_#{publisher.id}"
      within 'h1' do
        expect(page).to have_content "Iello"
      end

    end

    it "Shows a publisher details from a collection details" do
      publisher = FactoryGirl.create(:publisher, name: "Iello")
      collection = FactoryGirl.create(:collection, name: "Great Collection", publisher_id: publisher.id)
      visit collections_url
      click_link "show_collection_#{collection.id}"
      within 'h1' do
        expect(page).to have_content "Great Collection"
      end
      click_link "show_publisher_#{publisher.id}"
      within 'h1' do
        expect(page).to have_content "Iello"
      end

    end

    it "Shows a publisher items" do
      publisher = FactoryGirl.create(:publisher, name: "Iello")
      item = FactoryGirl.create(:item, title: "Wazabi", publisher_id: publisher.id)
      item2 = FactoryGirl.create(:item, title: "Hanabi")
      visit publishers_url
      click_link "show_items_of_publisher_#{publisher.id}"
      within 'h1' do
        expect(page).to have_content "Iello items"
      end
      expect(page).to have_content "Wazabi"
      expect(page).to_not have_content "Hanabi"
    end


    it "Shows a publisher collections" do
      publisher = FactoryGirl.create(:publisher, name: "Iello")
      collection = FactoryGirl.create(:collection, name: "Great Collection", publisher_id: publisher.id)
      collection2 = FactoryGirl.create(:collection, name: "Bad Collection")
      visit publishers_url
      click_link "show_collections_of_publisher_#{publisher.id}"
      within 'h1' do
        expect(page).to have_content "Iello collections"
      end
      expect(page).to have_content "Great Collection"
      expect(page).to_not have_content "Bad Collection"
    end

    it "Updates a publisher and displays the results" do
      publisher = FactoryGirl.create(:publisher, name: "Iello")
      visit publishers_url
      expect{
        click_link "edit_publisher_#{publisher.id}"
        fill_in 'Name', with: "Days of Wonder"
        click_button "Save Publisher"
      }.to_not change(Publisher,:count)
      within 'h1' do
        expect(page).to have_content "Days of Wonder"
      end
    end

    it "Deletes a publisher" do
      publisher = FactoryGirl.create(:publisher, name: "Iello")
      visit publishers_path
      expect{
          click_link "del_publisher_#{publisher.id}"
      }.to change(Publisher,:count).by(-1)
      expect(page).to have_content "All publishers"
      expect(page).to_not have_content "Iello"
    end

    it "Deletes an publisher with js dialog", js: true do
      DatabaseCleaner.clean
      publisher = FactoryGirl.create(:publisher, name: "Iello")
      visit publishers_path
      sleep 1
      expect{
          click_link "del_publisher_#{publisher.id}"
          sleep 1
          alert = page.driver.browser.switch_to.alert
          alert.accept
          sleep 1
      }.to change(Publisher,:count).by(-1)
      expect(page).to have_content "All publishers"
      expect(page).to_not have_content "Iello"
    end

  end

end
