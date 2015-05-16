require 'rails_helper'

describe "Illustrators" do

  describe "Manage illustrators" do

    it "Adds a new illustrator and displays the results" do
      visit illustrators_url
      expect{
        click_link 'New illustrator'
        fill_in 'Firstname', with: "John"
        fill_in 'Lastname', with: "Smith"
        click_button "Save Illustrator"
      }.to change(Illustrator,:count).by(1)
      within 'h1' do
        expect(page).to have_content "John Smith"
      end
    end

    it "Shows an illustrator details" do
      illustrator = FactoryGirl.create(:illustrator, firstname: "Larry", lastname: "Smith")
      visit illustrators_url
      expect{
        click_link "show_illustrator_#{illustrator.id}"
      }.to_not change(Illustrator,:count)
      within 'h1' do
        expect(page).to have_content "Larry Smith"
      end
    end

    it "Shows an illustrator details from an item details" do
      illustrator = FactoryGirl.create(:illustrator, firstname: "Larry", lastname: "Smith")
      item = FactoryGirl.create(:item, title: "Wazabi", illustrator_ids: [illustrator.id])
      visit items_url
      click_link "show_item_#{item.id}"
      within 'h1' do
        expect(page).to have_content "Wazabi"
      end
      click_link "show_illustrator_#{illustrator.id}"
      within 'h1' do
        expect(page).to have_content "Larry Smith"
      end

    end

    it "Shows an illustrator items" do
      illustrator = FactoryGirl.create(:illustrator, firstname: "Larry", lastname: "Smith")
      item = FactoryGirl.create(:item, title: "Wazabi", illustrator_ids: [illustrator.id])
      item2 = FactoryGirl.create(:item, title: "Hanabi", illustrator_ids: [])
      visit illustrators_url
      click_link "show_items_of_illustrator_#{illustrator.id}"
      within 'h1' do
        expect(page).to have_content "Larry Smith''s items"
      end
      expect(page).to have_content "Wazabi"
      expect(page).to_not have_content "Hanabi"
    end

    it "Updates an illustrator and displays the results" do
      illustrator = FactoryGirl.create(:illustrator, firstname: "Larry", lastname: "Smith")
      visit illustrators_url
      expect{
        click_link "edit_illustrator_#{illustrator.id}"
        fill_in 'Firstname', with: "Lawrence"
        click_button "Save Illustrator"
      }.to_not change(Illustrator,:count)
      within 'h1' do
        expect(page).to have_content "Lawrence Smith"
      end
    end

    it "Deletes an illustrator" do
      illustrator = FactoryGirl.create(:illustrator, firstname: "John", lastname: "Doe")
      visit illustrators_path
      expect{
          click_link "del_illustrator_#{illustrator.id}"
      }.to change(Illustrator,:count).by(-1)
      expect(page).to have_content "All illustrators"
      expect(page).to_not have_content "John Doe"
    end

    it "Deletes an illustrator with js dialog", js: true do
      DatabaseCleaner.clean
      illustrator = FactoryGirl.create(:illustrator, firstname: "John", lastname: "Doe")
      visit illustrators_path
      sleep 1
      expect{
          click_link "del_illustrator_#{illustrator.id}"
          sleep 1
          alert = page.driver.browser.switch_to.alert
          alert.accept
          sleep 1
      }.to change(Illustrator,:count).by(-1)
      expect(page).to have_content "All illustrators"
      expect(page).to_not have_content "John Doe"
    end

  end

end
