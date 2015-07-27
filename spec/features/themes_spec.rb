require 'rails_helper'

describe "Themes" do

  describe "Manage themes" do
    context 'with according rights' do

      before :each do
        @role = FactoryGirl.create(:role, name: 'Team')
        @user = FactoryGirl.create(:user, :donald, roles: Role.where(name: 'Team'))
      end

      it "Adds a new theme and displays the results" do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        visit themes_url
        expect{
          click_link 'New theme'
          fill_in 'Name', with: "Networks"
          click_button "Save Theme"
        }.to change(Theme,:count).by(1)
        within 'h1' do
          expect(page).to have_content "Networks"
        end
      end

      it "Adds a theme from an item form and displays it in the form"

      it "Adds a theme from an item details and displays the results" do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        item = FactoryGirl.create(:item, title: "Ticket To Ride")
        theme = FactoryGirl.create(:theme, name: "Networks", item_ids: item.id)
        visit items_url
        click_link "show_item_#{item.id}"
        within 'h1' do
          expect(page).to have_content "Ticket To Ride"
        end
        expect{
          click_link "new_theme"
          fill_in 'Name', with: "Rails"
          fill_in 'About', with: "A theme to classify items about rails transportation"
          click_button "Save Theme"
        }.to change(Theme,:count).by(1)
        within 'h1' do
          expect(page).to have_content "Rails"
        end
        ### The item is not associated to the newly created theme => requires a new controller method 
        expect(page).to have_content("#{item.title}")
        visit items_url
        click_link "show_item_#{item.id}"
        expect(page).to have_content "#{item.theme.last.name}"
      end

      it "Shows a theme details" do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        theme = FactoryGirl.create(:theme, name: "Networks")
        visit themes_url
        expect{
          click_link "show_theme_#{theme.id}"
        }.to_not change(Theme,:count)
        within 'h1' do
          expect(page).to have_content "Networks"
        end
      end

      it "Shows a theme details from an item details" do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        theme = FactoryGirl.create(:theme, name: "Iello")
        item = FactoryGirl.create(:item, title: "Wazabi", theme_ids: theme.id)
        visit items_url
        click_link "show_item_#{item.id}"
        within 'h1' do
          expect(page).to have_content "Wazabi"
        end
        click_link "show_theme_#{theme.id}"
        within 'h1' do
          expect(page).to have_content "Iello"
        end

      end

      it "Shows a theme items" do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        theme = FactoryGirl.create(:theme, name: "Iello")
        item = FactoryGirl.create(:item, title: "Wazabi", theme_ids: theme.id)
        item2 = FactoryGirl.create(:item, title: "Hanabi")
        visit themes_url
        click_link "show_items_of_theme_#{theme.id}"
        within 'h1' do
          expect(page).to have_content "Iello"
        end
        expect(page).to have_content "Wazabi"
        expect(page).to_not have_content "Hanabi"
      end

      it "Updates a theme and displays the results" do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        theme = FactoryGirl.create(:theme, name: "Iello")
        visit themes_url
        expect{
          click_link "edit_theme_#{theme.id}"
          fill_in 'Name', with: "Days of Wonder"
          click_button "Save Theme"
        }.to_not change(Theme,:count)
        within 'h1' do
          expect(page).to have_content "Days of Wonder"
        end
      end

      it "Updates a theme from its details page and displays the results" do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        theme = FactoryGirl.create(:theme, name: "Iello")
        visit themes_url
        click_link "show_theme_#{theme.id}"
        expect{
          click_link "edit_theme_#{theme.id}"
          fill_in 'Name', with: "Days of Wonder"
          click_button "Save Theme"
        }.to_not change(Theme,:count)
        within 'h1' do
          expect(page).to have_content "Days of Wonder"
        end
      end

      it "Deletes a theme" do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        theme = FactoryGirl.create(:theme, name: "Iello")
        visit themes_path
        expect{
          click_link "del_theme_#{theme.id}"
        }.to change(Theme,:count).by(-1)
        expect(page).to have_content "All themes"
        expect(page).to_not have_content "Iello"
      end

      it "Deletes an theme with js dialog", js: true do
        DatabaseCleaner.clean
        @role = FactoryGirl.create(:role, name: 'Team')
        @user = FactoryGirl.create(:user, :donald, roles: Role.where(name: 'Team'))
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        theme = FactoryGirl.create(:theme, name: "Iello")
        visit themes_path
        sleep 1
        expect{
          click_link "del_theme_#{theme.id}"
          sleep 1
          alert = page.driver.browser.switch_to.alert
          alert.accept
          sleep 1
        }.to change(Theme,:count).by(-1)
        expect(page).to have_content "All themes"
        expect(page).to_not have_content "Iello"
      end

      it "Deletes a theme from its details page" do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        theme = FactoryGirl.create(:theme, name: "Iello")
        visit themes_path
        click_link "show_theme_#{theme.id}"
        expect{
          click_link "del_theme_#{theme.id}"
        }.to change(Theme,:count).by(-1)
        expect(page).to have_content "All themes"
        expect(page).to_not have_content "Iello"
      end

      it "Deletes an theme from its details page with js dialog", js: true do
        DatabaseCleaner.clean
        @role = FactoryGirl.create(:role, name: 'Team')
        @user = FactoryGirl.create(:user, :donald, roles: Role.where(name: 'Team'))
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        theme = FactoryGirl.create(:theme, name: "Iello")
        visit themes_path
        click_link "show_theme_#{theme.id}"
        sleep 1
        expect{
          click_link "del_theme_#{theme.id}"
          sleep 1
          alert = page.driver.browser.switch_to.alert
          alert.accept
          sleep 1
        }.to change(Theme,:count).by(-1)
        expect(page).to have_content "All themes"
        expect(page).to_not have_content "Iello"
      end


    end

    context 'with basic rights' do
      before :each do
        @role = FactoryGirl.create(:role, name: 'Member')
        @user = FactoryGirl.create(:user, :donald, roles: Role.where(name: 'Member'))
      end
      it 'Prevents from creating a new theme' do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        visit themes_url
        expect(page).to_not have_link "New theme"
      end

      it 'Shows a theme details' do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        theme = FactoryGirl.create(:theme, name: "Iello")
        visit themes_url
        expect{
          click_link "show_theme_#{theme.id}"
        }.to_not change(Theme,:count)
        within 'h1' do
          expect(page).to have_content "Iello"
        end
      end

      it "Shows a theme details from an item details" do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        theme = FactoryGirl.create(:theme, name: "Iello")
        item = FactoryGirl.create(:item, title: "Wazabi", theme_ids: theme.id)
        visit items_url
        click_link "show_item_#{item.id}"
        within 'h1' do
          expect(page).to have_content "Wazabi"
        end
        click_link "show_theme_#{theme.id}"
        within 'h1' do
          expect(page).to have_content "Iello"
        end

      end

      it "Shows a theme items" do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        theme = FactoryGirl.create(:theme, name: "Iello")
        item = FactoryGirl.create(:item, title: "Wazabi", theme_ids: theme.id)
        item2 = FactoryGirl.create(:item, title: "Hanabi")
        visit themes_url
        click_link "show_items_of_theme_#{theme.id}"
        within 'h1' do
          expect(page).to have_content "Iello"
        end
        expect(page).to have_content "Wazabi"
        expect(page).to_not have_content "Hanabi"
      end

      it 'Prevents from updating a theme' do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        theme = FactoryGirl.create(:theme, name: "Iello")
        visit themes_url
        expect(page).to_not have_link "edit_theme_#{theme.id}"
      end

      it 'Prevents from updating a theme from its details page' do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        theme = FactoryGirl.create(:theme, name: "Iello")
        visit themes_url
        click_link "show_theme_#{theme.id}"
        expect(page).to_not have_link "edit_theme_#{theme.id}"
      end

      it 'Prevents from deleting a theme' do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        theme = FactoryGirl.create(:theme, name: "Iello")
        visit themes_url
        expect(page).to_not have_link "del_theme_#{theme.id}"
      end

      it 'Prevents from deleting a theme from its details page' do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        theme = FactoryGirl.create(:theme, name: "Iello")
        visit themes_url
        click_link "show_theme_#{theme.id}"
        expect(page).to_not have_link "del_theme_#{theme.id}"
      end


      it "Prevents from deleting a theme from a item details" # do
      #   sign_in_with_donald
      #   expect(page).to have_link 'Log out'
      #   expect(page).to have_content 'Member'
      #   item = FactoryGirl.create(:item, title: "Iellone")
      #   theme = FactoryGirl.create(:theme, name: "Great Theme", item_ids: item.id)
      #   visit items_url
      #   click_link "show_item_#{item.id}"
      #   within 'h1' do
      #     expect(page).to have_content "Iellone"
      #   end
      #   expect(page).to_not have_link "del_theme_#{theme.id}"
      # end

    end

    context 'as guest'do
    it 'Prevents from creating a new theme'
    it 'Shows a theme details'
    it 'Shows a theme details from an item details'
    it 'Shows a theme details from a publisher details'
    it 'Shows a theme items'
    it 'Prevents from updating a theme'
    it 'Prevents from deleting a theme'
  end
end

end
