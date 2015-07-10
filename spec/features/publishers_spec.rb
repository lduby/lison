require 'rails_helper'

describe "Publishers" do

  describe "Manage publishers" do
    context 'with according rights' do
      before :each do

        @role = FactoryGirl.create(:role, name: 'Team')
        @user = FactoryGirl.create(:user, :donald, roles: Role.where(name: 'Team'))
      end
      it "Adds a new publisher and displays the results" do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
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
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
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
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
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

        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'

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
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
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

        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'

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
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
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

      it "Updates a publisher and displays the results" do
        publisher = FactoryGirl.create(:publisher, name: "Iello")
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        visit publishers_url
        click_link "show_publisher_#{publisher.id}"
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
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        visit publishers_path
        expect{
          click_link "del_publisher_#{publisher.id}"
        }.to change(Publisher,:count).by(-1)
        expect(page).to have_content "All publishers"
        expect(page).to_not have_content "Iello"
      end

      it "Deletes a publisher with js dialog", js: true do
        DatabaseCleaner.clean
        @role = FactoryGirl.create(:role, name: 'Team')
        @user = FactoryGirl.create(:user, :donald, roles: Role.where(name: 'Team'))
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
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

      it "Deletes a publisher from its details page" do
        publisher = FactoryGirl.create(:publisher, name: "Iello")
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        visit publishers_path
        click_link "show_publisher_#{publisher.id}"
        expect{
          click_link "del_publisher_#{publisher.id}"
        }.to change(Publisher,:count).by(-1)
        expect(page).to have_content "All publishers"
        expect(page).to_not have_content "Iello"
      end

      it "Deletes an publisher from its details page with js dialog", js: true do
        DatabaseCleaner.clean
        @role = FactoryGirl.create(:role, name: 'Team')
        @user = FactoryGirl.create(:user, :donald, roles: Role.where(name: 'Team'))
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        publisher = FactoryGirl.create(:publisher, name: "Iello")
        visit publishers_path
        click_link "show_publisher_#{publisher.id}"
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


    context 'with basic rights' do
      before :each do

        @role = FactoryGirl.create(:role, name: 'Member')
        @user = FactoryGirl.create(:user, :donald, roles: Role.where(name: 'Member'))
      end
      it "Prevents from adding a new publisher" do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        visit publishers_url
        expect(page).to_not have_link 'New publisher'
      end

      it "Shows a publisher details" do
        publisher = FactoryGirl.create(:publisher, name: "Iello")
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
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
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
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

        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'

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
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
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

        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'

        visit publishers_url
        click_link "show_collections_of_publisher_#{publisher.id}"
        within 'h1' do
          expect(page).to have_content "Iello collections"
        end
        expect(page).to have_content "Great Collection"
        expect(page).to_not have_content "Bad Collection"
      end

      it "Prevents from updating a publisher" do
        publisher = FactoryGirl.create(:publisher, name: "Iello")
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        visit publishers_url
        expect(page).to_not have_link "edit_publisher_#{publisher.id}"
      end


      it "Prevents from updating a publisher from its details page" do
        publisher = FactoryGirl.create(:publisher, name: "Iello")
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        visit publishers_url
        click_link "show_publisher_#{publisher.id}"
        expect(page).to_not have_link "edit_publisher_#{publisher.id}"
      end

      it "Prevents from deleting a publisher" do
        publisher = FactoryGirl.create(:publisher, name: "Iello")
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        visit publishers_path
        expect(page).to_not have_link "del_publisher_#{publisher.id}"
      end

      it "Prevents from deleting a publisher from its details page " do
        publisher = FactoryGirl.create(:publisher, name: "Iello")
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        visit publishers_path
        click_link "show_publisher_#{publisher.id}"
        expect(page).to_not have_link "del_publisher_#{publisher.id}"
      end
    end


  end

end
