require 'rails_helper'

describe "Authors" do

  describe "Manage authors" do

    context 'with according rights' do

      before :each do
        @role = FactoryGirl.create(:role, name: 'Team')
        @user = FactoryGirl.create(:user, :donald, roles: Role.where(name: 'Team'))
      end

      it "Adds a new author and displays the results" do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        visit authors_url
        expect{
          click_link 'New author'
          fill_in 'Firstname', with: "John"
          fill_in 'Lastname', with: "Smith"
          click_button "Create Author"
        }.to change(Author,:count).by(1)
        within 'h1' do
          expect(page).to have_content "John Smith"
        end
      end

      it "Adds an author from an item form and associates it to the item" do
         sign_in_with_donald
         expect(page).to have_link 'Log out'
         expect(page).to have_content 'Team'
         visit items_url
         expect{
            click_link 'New item'
            fill_in 'Title', with: "Tickets To Ride Again"
            fill_in "item_authors_attributes_0_lastname", with: "Pol"
            fill_in "item_authors_attributes_0_firstname", with: "Jak"
            click_button "Create Item"
         }.to change(Author,:count).by(1)
         within 'ul#item_authors_list' do
           expect(page).to have_content "Jak Pol"
         end
         visit authors_url
         expect(page).to have_content "Jak Pol"
         click_link "show_author_#{Author.all.last.id}"
         expect(page).to have_content "Tickets To Ride Again"
      end

      it "Shows an author details" do
        author = FactoryGirl.create(:author, firstname: "Larry", lastname: "Smith")
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        visit authors_url
        expect{
          click_link "show_author_#{author.id}"
        }.to_not change(Author,:count)
        within 'h1' do
          expect(page).to have_content "Larry Smith"
        end
      end

      it "Shows an author details from an item details" do
        author = FactoryGirl.create(:author, firstname: "Larry", lastname: "Smith")
        item = FactoryGirl.create(:item, title: "Wazabi", author_ids: [author.id])
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        visit items_url
        click_link "show_item_#{item.id}"
        within 'h1' do
          expect(page).to have_content "Wazabi"
        end
        click_link "show_author_#{author.id}"
        within 'h1' do
          expect(page).to have_content "Larry Smith"
        end

      end

      it "Shows an author items" do
        author = FactoryGirl.create(:author, firstname: "Larry", lastname: "Smith")
        item = FactoryGirl.create(:item, title: "Wazabi", author_ids: [author.id])
        item2 = FactoryGirl.create(:item, title: "Hanabi", author_ids: [])
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        visit authors_url
        click_link "show_items_of_author_#{author.id}"
        within 'h1' do
          expect(page).to have_content "Larry Smith''s items"
        end
        expect(page).to have_content "Wazabi"
        expect(page).to_not have_content "Hanabi"
      end

      it "Updates an author and displays the results" do
        author = FactoryGirl.create(:author, firstname: "Larry", lastname: "Smith")
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        visit authors_url
        expect{
          click_link "edit_author_#{author.id}"
          fill_in 'Firstname', with: "Lawrence"
          click_button "Update Author"
        }.to_not change(Author,:count)
        within 'h1' do
          expect(page).to have_content "Lawrence Smith"
        end
      end

      it "Deletes an author" do
        author = FactoryGirl.create(:author, firstname: "John", lastname: "Doe")
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        visit authors_path
        expect{
          click_link "del_author_#{author.id}"
        }.to change(Author,:count).by(-1)
        expect(page).to have_content "All authors"
        expect(page).to_not have_content "John Doe"
      end

      it "Deletes an author with js dialog", js: true do
        DatabaseCleaner.clean
        @role = FactoryGirl.create(:role, name: 'Team')
        @user = FactoryGirl.create(:user, :donald, roles: Role.where(name: 'Team'))
        author = FactoryGirl.create(:author, firstname: "John", lastname: "Doe")
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
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

    context 'with basic rights' do

      before :each do
        @role = FactoryGirl.create(:role, name: 'Member')
        @user = FactoryGirl.create(:user, :donald, roles: Role.where(name: 'Member'))
      end


      it "Prevents adding a new author" do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        visit authors_url
        expect(page).to_not have_link 'New author'
      end

      it "Shows an author details" do
        author = FactoryGirl.create(:author, firstname: "Larry", lastname: "Smith")
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        visit authors_url
        expect{
          click_link "show_author_#{author.id}"
        }.to_not change(Author,:count)
        within 'h1' do
          expect(page).to have_content "Larry Smith"
        end
      end

      it "Shows an author details from an item details" do
        author = FactoryGirl.create(:author, firstname: "Larry", lastname: "Smith")
        item = FactoryGirl.create(:item, title: "Wazabi", author_ids: [author.id])
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        visit items_url
        click_link "show_item_#{item.id}"
        within 'h1' do
          expect(page).to have_content "Wazabi"
        end
        click_link "show_author_#{author.id}"
        within 'h1' do
          expect(page).to have_content "Larry Smith"
        end

      end

      it "Shows an author items" do
        author = FactoryGirl.create(:author, firstname: "Larry", lastname: "Smith")
        item = FactoryGirl.create(:item, title: "Wazabi", author_ids: [author.id])
        item2 = FactoryGirl.create(:item, title: "Hanabi", author_ids: [])
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        visit authors_url
        click_link "show_items_of_author_#{author.id}"
        within 'h1' do
          expect(page).to have_content "Larry Smith''s items"
        end
        expect(page).to have_content "Wazabi"
        expect(page).to_not have_content "Hanabi"
      end

      it "Prevents from updating an author" do
        author = FactoryGirl.create(:author, firstname: "Larry", lastname: "Smith")
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        visit authors_url
        expect(page).to_not have_link "edit_author_#{author.id}"
      end

      it "Prevents from updating an author from its details" do
        author = FactoryGirl.create(:author, firstname: "Larry", lastname: "Smith")
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        visit authors_url
        click_link "show_author_#{author.id}"
        expect(page).to_not have_link "edit_author_#{author.id}"
      end

      it "Prevents from deleting an author" do
        author = FactoryGirl.create(:author, firstname: "John", lastname: "Doe")
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        visit authors_path
        expect(page).to_not have_link "del_author_#{author.id}"
      end

      it "Prevents from deleting an author from its details" do
        author = FactoryGirl.create(:author, firstname: "John", lastname: "Doe")
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        visit authors_path
        click_link "show_author_#{author.id}"
        expect(page).to_not have_link "del_author_#{author.id}"
      end


    end

  end

end
