require 'rails_helper'

describe "Categories" do

  describe "Manage categories" do
    context 'with according rights' do

      before :each do
        @role = FactoryGirl.create(:role, name: 'Team')
        @user = FactoryGirl.create(:user, :donald, roles: Role.where(name: 'Team'))
      end

      it "Adds a new category and displays the results" do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        visit categories_url
        expect{
          click_link 'New category'
          fill_in 'Name', with: "Networks"
          click_button "Save Category"
        }.to change(Category,:count).by(1)
        within 'h1' do
          expect(page).to have_content "Networks"
        end
      end

      it "Adds a category from an item form and displays it in the form"

      it "Adds a category from an item details and displays the results" do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        item = FactoryGirl.create(:item, title: "Ticket To Ride")
        category = FactoryGirl.create(:category, name: "Networks", item_ids: item.id)
        visit items_url
        click_link "show_item_#{item.id}"
        within 'h1' do
          expect(page).to have_content "Ticket To Ride"
        end
        expect{
          click_link "new_category"
          fill_in 'Name', with: "Rails"
          fill_in 'About', with: "A category to classify items about rails transportation"
          click_button "Save Category"
        }.to change(Category,:count).by(1)
        within 'h1' do
          expect(page).to have_content "Rails"
        end
        ### The item is not associated to the newly created category => requires a new controller method 
        expect(page).to have_content("#{item.title}")
        visit items_url
        click_link "show_item_#{item.id}"
        expect(page).to have_content "#{item.category.last.name}"
      end

      it "Shows a category details" do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        category = FactoryGirl.create(:category, name: "Networks")
        visit categories_url
        expect{
          click_link "show_category_#{category.id}"
        }.to_not change(Category,:count)
        within 'h1' do
          expect(page).to have_content "Networks"
        end
      end

      it "Shows a category details from an item details" do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        category = FactoryGirl.create(:category, name: "Iello")
        item = FactoryGirl.create(:item, title: "Wazabi", category_ids: category.id)
        visit items_url
        click_link "show_item_#{item.id}"
        within 'h1' do
          expect(page).to have_content "Wazabi"
        end
        click_link "show_category_#{category.id}"
        within 'h1' do
          expect(page).to have_content "Iello"
        end

      end

      it "Shows a category items" do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        category = FactoryGirl.create(:category, name: "Iello")
        item = FactoryGirl.create(:item, title: "Wazabi", category_ids: category.id)
        item2 = FactoryGirl.create(:item, title: "Hanabi")
        visit categories_url
        click_link "show_items_of_category_#{category.id}"
        within 'h1' do
          expect(page).to have_content "Iello"
        end
        expect(page).to have_content "Wazabi"
        expect(page).to_not have_content "Hanabi"
      end

      it "Updates a category and displays the results" do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        category = FactoryGirl.create(:category, name: "Iello")
        visit categories_url
        expect{
          click_link "edit_category_#{category.id}"
          fill_in 'Name', with: "Days of Wonder"
          click_button "Save Category"
        }.to_not change(Category,:count)
        within 'h1' do
          expect(page).to have_content "Days of Wonder"
        end
      end

      it "Updates a category from its details page and displays the results" do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        category = FactoryGirl.create(:category, name: "Iello")
        visit categories_url
        click_link "show_category_#{category.id}"
        expect{
          click_link "edit_category_#{category.id}"
          fill_in 'Name', with: "Days of Wonder"
          click_button "Save Category"
        }.to_not change(Category,:count)
        within 'h1' do
          expect(page).to have_content "Days of Wonder"
        end
      end

      it "Deletes a category" do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        category = FactoryGirl.create(:category, name: "Iello")
        visit categories_path
        expect{
          click_link "del_category_#{category.id}"
        }.to change(Category,:count).by(-1)
        expect(page).to have_content "All categories"
        expect(page).to_not have_content "Iello"
      end

      it "Deletes an category with js dialog", js: true do
        DatabaseCleaner.clean
        @role = FactoryGirl.create(:role, name: 'Team')
        @user = FactoryGirl.create(:user, :donald, roles: Role.where(name: 'Team'))
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        category = FactoryGirl.create(:category, name: "Iello")
        visit categories_path
        sleep 1
        expect{
          click_link "del_category_#{category.id}"
          sleep 1
          alert = page.driver.browser.switch_to.alert
          alert.accept
          sleep 1
        }.to change(Category,:count).by(-1)
        expect(page).to have_content "All categories"
        expect(page).to_not have_content "Iello"
      end

      it "Deletes a category from its details page" do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        category = FactoryGirl.create(:category, name: "Iello")
        visit categories_path
        click_link "show_category_#{category.id}"
        expect{
          click_link "del_category_#{category.id}"
        }.to change(Category,:count).by(-1)
        expect(page).to have_content "All categories"
        expect(page).to_not have_content "Iello"
      end

      it "Deletes an category from its details page with js dialog", js: true do
        DatabaseCleaner.clean
        @role = FactoryGirl.create(:role, name: 'Team')
        @user = FactoryGirl.create(:user, :donald, roles: Role.where(name: 'Team'))
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        category = FactoryGirl.create(:category, name: "Iello")
        visit categories_path
        click_link "show_category_#{category.id}"
        sleep 1
        expect{
          click_link "del_category_#{category.id}"
          sleep 1
          alert = page.driver.browser.switch_to.alert
          alert.accept
          sleep 1
        }.to change(Category,:count).by(-1)
        expect(page).to have_content "All categories"
        expect(page).to_not have_content "Iello"
      end


    end

    context 'with basic rights' do
      before :each do
        @role = FactoryGirl.create(:role, name: 'Member')
        @user = FactoryGirl.create(:user, :donald, roles: Role.where(name: 'Member'))
      end
      it 'Prevents from creating a new category' do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        visit categories_url
        expect(page).to_not have_link "New category"
      end

      it 'Shows a category details' do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        category = FactoryGirl.create(:category, name: "Iello")
        visit categories_url
        expect{
          click_link "show_category_#{category.id}"
        }.to_not change(Category,:count)
        within 'h1' do
          expect(page).to have_content "Iello"
        end
      end

      it "Shows a category details from an item details" do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        category = FactoryGirl.create(:category, name: "Iello")
        item = FactoryGirl.create(:item, title: "Wazabi", category_ids: category.id)
        visit items_url
        click_link "show_item_#{item.id}"
        within 'h1' do
          expect(page).to have_content "Wazabi"
        end
        click_link "show_category_#{category.id}"
        within 'h1' do
          expect(page).to have_content "Iello"
        end

      end

      it "Shows a category items" do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        category = FactoryGirl.create(:category, name: "Iello")
        item = FactoryGirl.create(:item, title: "Wazabi", category_ids: category.id)
        item2 = FactoryGirl.create(:item, title: "Hanabi")
        visit categories_url
        click_link "show_items_of_category_#{category.id}"
        within 'h1' do
          expect(page).to have_content "Iello"
        end
        expect(page).to have_content "Wazabi"
        expect(page).to_not have_content "Hanabi"
      end

      it 'Prevents from updating a category' do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        category = FactoryGirl.create(:category, name: "Iello")
        visit categories_url
        expect(page).to_not have_link "edit_category_#{category.id}"
      end

      it 'Prevents from updating a category from its details page' do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        category = FactoryGirl.create(:category, name: "Iello")
        visit categories_url
        click_link "show_category_#{category.id}"
        expect(page).to_not have_link "edit_category_#{category.id}"
      end

      it 'Prevents from deleting a category' do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        category = FactoryGirl.create(:category, name: "Iello")
        visit categories_url
        expect(page).to_not have_link "del_category_#{category.id}"
      end

      it 'Prevents from deleting a category from its details page' do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        category = FactoryGirl.create(:category, name: "Iello")
        visit categories_url
        click_link "show_category_#{category.id}"
        expect(page).to_not have_link "del_category_#{category.id}"
      end


      it "Prevents from deleting a category from a item details" # do
      #   sign_in_with_donald
      #   expect(page).to have_link 'Log out'
      #   expect(page).to have_content 'Member'
      #   item = FactoryGirl.create(:item, title: "Iellone")
      #   category = FactoryGirl.create(:category, name: "Great Category", item_ids: item.id)
      #   visit items_url
      #   click_link "show_item_#{item.id}"
      #   within 'h1' do
      #     expect(page).to have_content "Iellone"
      #   end
      #   expect(page).to_not have_link "del_category_#{category.id}"
      # end

    end

    context 'as guest'do
    it 'Prevents from creating a new category'
    it 'Shows a category details'
    it 'Shows a category details from an item details'
    it 'Shows a category details from a publisher details'
    it 'Shows a category items'
    it 'Prevents from updating a category'
    it 'Prevents from deleting a category'
  end
end

end
