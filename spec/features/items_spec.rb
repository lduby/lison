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

    it "Adds a new item with an author and displays the results" do
      author = FactoryGirl.create(:author)
      visit items_url
      expect{
        click_link 'New item'
        fill_in 'Title', with: "Example Item"
        check "item_author_ids_#{author.id}"
        click_button "Save Item"
      }.to change(Item,:count).by(1)
      within 'h1' do
        expect(page).to have_content "Example Item"
      end
      expect(page).to have_content("Authors: #{author.name}")
      visit authors_url
      click_link "show_author_#{author.id}"
      expect(page).to have_content "#{Item.last.title}"

    end


    it "Shows an item details" do
      item = FactoryGirl.create(:item, title: "To be viewed item")
      visit items_url
      expect{
        click_link "show_item_#{item.id}"
      }.to_not change(Item,:count)
      within 'h1' do
        expect(page).to have_content "To be viewed item"
      end
    end

    it "Updates an item and displays the results" do
      item = FactoryGirl.create(:item, title: "To be updated item")
      visit items_url
      expect{
        click_link "edit_item_#{item.id}"
        fill_in 'Title', with: "Updated Item"
        click_button "Save Item"
      }.to_not change(Item,:count)
      within 'h1' do
        expect(page).to have_content "Updated Item"
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
      sleep 1
      expect{
          click_link "del_item_#{item.id}"
          sleep 1
          alert = page.driver.browser.switch_to.alert
          alert.accept
          sleep 1
      }.to change(Item,:count).by(-1)
      expect(page).to have_content "All items"
      expect(page).to_not have_content "To be deleted item"
    end

  end

end
