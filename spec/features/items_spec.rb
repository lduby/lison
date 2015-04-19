require 'rails_helper'

describe "Items" do

  describe "Manage items" do

    it "Adds a new item and displays the results" do
      visit items_url
      expect{
        click_link 'New item'
        fill_in 'Title', with: "Example Item"
        click_button "Save Item"
      }.to change(Item,:count).by(1)
      within 'h1' do
        expect(page).to have_content "Example Item"
      end
    end

    it "Deletes an item" do
      item = FactoryGirl.create(:item, title: "To be deleted item")
      visit items_path
      expect{
          click_link "del_item_#{item.id}"
      }.to change(Item,:count).by(-1)
      expect(page).to have_content "All items"
      expect(page).to_not have_content "To be deleted item"
    end

    it "Deletes an item with js dialog", js: true do
      DatabaseCleaner.clean
      item = FactoryGirl.create(:item, title: "To be deleted item")
      visit items_path
      expect{
          click_link "del_item_#{item.id}"
          alert = page.driver.browser.switch_to.alert
          alert.accept
      }.to change(Item,:count).by(-1)
      expect(page).to have_content "All items"
      expect(page).to_not have_content "To be deleted item"
    end

  end

end
