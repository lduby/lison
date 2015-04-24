require 'rails_helper'

describe "Authors" do

  describe "Manage authors" do

    it "Adds a new author and displays the results" do
      visit authors_url
      expect{
        click_link 'New author'
        fill_in 'Firstname', with: "John"
        fill_in 'Lastname', with: "Smith"
        click_button "Save Author"
      }.to change(Author,:count).by(1)
      within 'h1' do
        expect(page).to have_content "John Smith"
      end
    end

    it "Shows an author details" do
      author = FactoryGirl.create(:author, firstname: "Larry", lastname: "Smith")
      visit authors_url
      expect{
        click_link "show_author_#{author.id}"
      }.to_not change(Author,:count)
      within 'h1' do
        expect(page).to have_content "Larry Smith"
      end
    end

    it "Updates an author and displays the results" do
      author = FactoryGirl.create(:author, firstname: "Larry", lastname: "Smith")
      visit authors_url
      expect{
        click_link "edit_author_#{author.id}"
        fill_in 'Firstname', with: "Lawrence"
        click_button "Save Author"
      }.to_not change(Author,:count)
      within 'h1' do
        expect(page).to have_content "Lawrence Smith"
      end
    end

    it "Deletes an author" do
      author = FactoryGirl.create(:author, firstname: "John", lastname: "Doe")
      visit authors_path
      expect{
          click_link "del_author_#{author.id}"
      }.to change(Author,:count).by(-1)
      expect(page).to have_content "All authors"
      expect(page).to_not have_content "John Doe"
    end

    it "Deletes an author with js dialog", js: true do
      DatabaseCleaner.clean
      author = FactoryGirl.create(:author, firstname: "John", lastname: "Doe")
      visit authors_path
      sleep 1
      expect{
          click_link "del_author_#{author.id}"
          sleep 1
          alert = page.driver.browser.switch_to.alert
          alert.accept
          sleep 1
      }.to change(Author,:count).by(-1)
      expect(page).to have_content "All authors"
      expect(page).to_not have_content "John Doe"
    end

  end

end
