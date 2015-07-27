require 'rails_helper'

describe "Illustrators" do

  describe "Manage illustrators" do

    context 'with according rights' do

      before :each do
        @role = FactoryGirl.create(:role, name: 'Team')
        @user = FactoryGirl.create(:user, :donald, roles: Role.where(name: 'Team'))
      end


      it "Adds a new illustrator and displays the results" do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
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

      it "Adds an illustrator from an item form and displays it in the form"

      it "Shows an illustrator details" do
        illustrator = FactoryGirl.create(:illustrator, firstname: "Larry", lastname: "Smith")
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
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
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
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
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
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
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
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

      it "Updates an illustrator from its details and displays the results" do
        illustrator = FactoryGirl.create(:illustrator, firstname: "Larry", lastname: "Smith")
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        visit illustrators_url
        click_link "show_illustrator_#{illustrator.id}"
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
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        visit illustrators_path
        expect{
          click_link "del_illustrator_#{illustrator.id}"
        }.to change(Illustrator,:count).by(-1)
        expect(page).to have_content "All illustrators"
        expect(page).to_not have_content "John Doe"
      end

      it "Deletes an illustrator from its details" do
        illustrator = FactoryGirl.create(:illustrator, firstname: "John", lastname: "Doe")
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        visit illustrators_path
        click_link "show_illustrator_#{illustrator.id}"
        expect{
          click_link "del_illustrator_#{illustrator.id}"
        }.to change(Illustrator,:count).by(-1)
        expect(page).to have_content "All illustrators"
        expect(page).to_not have_content "John Doe"
      end

      it "Deletes an illustrator with js dialog", js: true do
        DatabaseCleaner.clean
        illustrator = FactoryGirl.create(:illustrator, firstname: "John", lastname: "Doe")
        @role = FactoryGirl.create(:role, name: 'Team')
        @user = FactoryGirl.create(:user, :donald, roles: Role.where(name: 'Team'))
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
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

    context 'with basic rights' do

      before :each do
        @role = FactoryGirl.create(:role, name: 'Member')
        @user = FactoryGirl.create(:user, :donald, roles: Role.where(name: 'Member'))
      end


      it "Prevents adding a new illustrator" do
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        visit illustrators_url
        expect(page).to_not have_link 'New illustrator'
      end

      it "Shows an illustrator details" do
        illustrator = FactoryGirl.create(:illustrator, firstname: "Larry", lastname: "Smith")
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
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
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
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
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        visit illustrators_url
        click_link "show_items_of_illustrator_#{illustrator.id}"
        within 'h1' do
          expect(page).to have_content "Larry Smith''s items"
        end
        expect(page).to have_content "Wazabi"
        expect(page).to_not have_content "Hanabi"
      end

      it "Prevents from updating an illustrator" do
        illustrator = FactoryGirl.create(:illustrator, firstname: "Larry", lastname: "Smith")
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        visit illustrators_url
        expect(page).to_not have_link "edit_illustrator_#{illustrator.id}"
      end

      it "Prevents from updating an illustrator from its details" do
        illustrator = FactoryGirl.create(:illustrator, firstname: "Larry", lastname: "Smith")
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        visit illustrators_url
        click_link "show_illustrator_#{illustrator.id}"
        expect(page).to_not have_link "edit_illustrator_#{illustrator.id}"
      end

      it "Prevents from deleting an illustrator" do
        illustrator = FactoryGirl.create(:illustrator, firstname: "John", lastname: "Doe")
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        visit illustrators_path
        expect(page).to_not have_link "del_illustrator_#{illustrator.id}"
      end

      it "Prevents from deleting an illustrator from its details" do
        illustrator = FactoryGirl.create(:illustrator, firstname: "John", lastname: "Doe")
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Member'
        visit illustrators_path
        click_link "show_illustrator_#{illustrator.id}"
        expect(page).to_not have_link "del_illustrator_#{illustrator.id}"
      end

    end

  end

end
