require 'rails_helper'

describe "Items" do

  describe "Manage items" do
    context 'with according rights' do
      before :each do

        @role = FactoryGirl.create(:role, name: 'Team')
        @user = FactoryGirl.create(:user, :donald, roles: Role.where(name: 'Team'))
      end
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

      it "Adds a new item with an illustrator and displays the results" do
        illustrator = FactoryGirl.create(:illustrator)
        visit items_url
        expect{
          click_link 'New item'
          fill_in 'Title', with: "Example Item"
          check "item_illustrator_ids_#{illustrator.id}"
          click_button "Save Item"
        }.to change(Item,:count).by(1)
        within 'h1' do
          expect(page).to have_content "Example Item"
        end
        expect(page).to have_content("Illustrators: #{illustrator.name}")
        visit illustrators_url
        click_link "show_illustrator_#{illustrator.id}"
        expect(page).to have_content "#{Item.last.title}"

      end

      it "Adds a new item with a publisher and displays the results" do
        publisher = FactoryGirl.create(:publisher)
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        visit items_url
        expect{
          click_link 'New item'
          fill_in 'Title', with: "Example Item"
          select "#{publisher.name}", :from => 'item_publisher_id'
          click_button "Save Item"
        }.to change(Item,:count).by(1)
        within 'h1' do
          expect(page).to have_content "Example Item"
        end
        expect(page).to have_content("Publisher: #{publisher.name}")
        visit publishers_url
        click_link "show_publisher_#{publisher.id}"
        expect(page).to have_content "#{Item.last.title}"

      end

      it "Adds a new item with a collection and displays the results" do
        collection = FactoryGirl.create(:collection)
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        visit items_url
        expect{
          click_link 'New item'
          fill_in 'Title', with: "Example Item"
          select "#{collection.name}", :from => 'item_collection_id'
          click_button "Save Item"
        }.to change(Item,:count).by(1)
        within 'h1' do
          expect(page).to have_content "Example Item"
        end
        expect(page).to have_content("Collection: #{collection.name}")
        visit collections_url
        click_link "show_collection_#{collection.id}"
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

      it "Shows an item details from an author items list" do
        author = FactoryGirl.create(:author, firstname: "Larry", lastname: "Smith")
        item = FactoryGirl.create(:item, title: "Wazabi", author_ids: [author.id])
        item2 = FactoryGirl.create(:item, title: "Hanabi", author_ids: [author.id])
        visit authors_url
        click_link "show_items_of_author_#{author.id}"
        click_link "show_item_#{item.id}"
        within 'h1' do
          expect(page).to have_content "Wazabi"
        end
      end

      it "Shows an item details from an illustrator items list" do
        illustrator = FactoryGirl.create(:illustrator, firstname: "Larry", lastname: "Smith")
        item = FactoryGirl.create(:item, title: "Wazabi", illustrator_ids: [illustrator.id])
        item2 = FactoryGirl.create(:item, title: "Hanabi", illustrator_ids: [illustrator.id])
        visit illustrators_url
        click_link "show_items_of_illustrator_#{illustrator.id}"
        click_link "show_item_#{item.id}"
        within 'h1' do
          expect(page).to have_content "Wazabi"
        end
      end

      it "Shows an item details from a publisher items list" do
        publisher = FactoryGirl.create(:publisher, name: "Iello")
        item = FactoryGirl.create(:item, title: "Wazabi", publisher_id: publisher.id)
        item2 = FactoryGirl.create(:item, title: "Hanabi", publisher_id: publisher.id)
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        visit publishers_url
        click_link "show_items_of_publisher_#{publisher.id}"
        click_link "show_item_#{item.id}"
        within 'h1' do
          expect(page).to have_content "Wazabi"
        end
      end

      it "Shows an item details from a collection items list" do
        collection = FactoryGirl.create(:collection, name: "Iello")
        item = FactoryGirl.create(:item, title: "Wazabi", collection_id: collection.id)
        item2 = FactoryGirl.create(:item, title: "Hanabi", collection_id: collection.id)
        visit collections_url
        click_link "show_items_of_collection_#{collection.id}"
        click_link "show_item_#{item.id}"
        within 'h1' do
          expect(page).to have_content "Wazabi"
        end
      end

      it "Updates an item from an author items list and displays the results" do
        author = FactoryGirl.create(:author, firstname: "Larry", lastname: "Smith")
        item = FactoryGirl.create(:item, title: "Wazabi", author_ids: [author.id])
        visit authors_url
        click_link "show_items_of_author_#{author.id}"
        expect{
          click_link "edit_item_#{item.id}"
          fill_in 'Title', with: "Hanabi"
          click_button "Save Item"
        }.to_not change(Item,:count)
        within 'h1' do
          expect(page).to have_content "Hanabi"
        end
      end

      it "Updates an item from an illustrator items list and displays the results" do
        illustrator = FactoryGirl.create(:illustrator, firstname: "Larry", lastname: "Smith")
        item = FactoryGirl.create(:item, title: "Wazabi", illustrator_ids: [illustrator.id])
        visit illustrators_url
        click_link "show_items_of_illustrator_#{illustrator.id}"
        expect{
          click_link "edit_item_#{item.id}"
          fill_in 'Title', with: "Hanabi"
          click_button "Save Item"
        }.to_not change(Item,:count)
        within 'h1' do
          expect(page).to have_content "Hanabi"
        end
      end

      it "Updates an item from a publisher items list and displays the results" do
        publisher = FactoryGirl.create(:publisher, name: "Iello")
        item = FactoryGirl.create(:item, title: "Wazabi", publisher_id: publisher.id)
        visit publishers_url
        click_link "show_items_of_publisher_#{publisher.id}"
        expect{
          click_link "edit_item_#{item.id}"
          fill_in 'Title', with: "Hanabi"
          click_button "Save Item"
        }.to_not change(Item,:count)
        within 'h1' do
          expect(page).to have_content "Hanabi"
        end
      end

      it "Updates an item from a collection items list and displays the results" do
        collection = FactoryGirl.create(:collection, name: "Iello")
        item = FactoryGirl.create(:item, title: "Wazabi", collection_id: collection.id)
        visit collections_url
        click_link "show_items_of_collection_#{collection.id}"
        expect{
          click_link "edit_item_#{item.id}"
          fill_in 'Title', with: "Hanabi"
          click_button "Save Item"
        }.to_not change(Item,:count)
        within 'h1' do
          expect(page).to have_content "Hanabi"
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

      it "Adds an author and displays the results" do
        author1 = FactoryGirl.create(:author)
        author2 = FactoryGirl.create(:author)
        item = FactoryGirl.create(:item, author_ids: [author1.id] )
        visit items_url
        click_link "edit_item_#{item.id}"
        check "item_author_ids_#{author2.id}"
        click_button "Save Item"
        expect(page).to have_content "#{item.title}"
        expect(page).to have_content "Authors: #{author1.name} #{author2.name}"
        visit authors_url
        click_link "show_items_of_author_#{author1.id}"
        expect(page).to have_content "#{item.title}"
        visit authors_url
        click_link "show_items_of_author_#{author2.id}"
        expect(page).to have_content "#{item.title}"
      end

      it "Removes an author and displays the results" do
        author1 = FactoryGirl.create(:author)
        author2 = FactoryGirl.create(:author)
        item = FactoryGirl.create(:item, author_ids: [author1.id, author2.id] )
        visit items_url
        click_link "edit_item_#{item.id}"
        uncheck "item_author_ids_#{author2.id}"
        click_button "Save Item"
        expect(page).to have_content "#{item.title}"
        expect(page).to have_content "Authors: #{author1.name}"
        visit authors_url
        click_link "show_items_of_author_#{author1.id}"
        expect(page).to have_content "#{item.title}"
        visit authors_url
        click_link "show_items_of_author_#{author2.id}"
        expect(page).to_not have_content "#{item.title}"
      end

      it "Adds an illustrator and displays the resuts" do
        illu1 = FactoryGirl.create(:illustrator)
        illu2 = FactoryGirl.create(:illustrator)
        item = FactoryGirl.create(:item, illustrator_ids: [illu1.id] )
        visit items_url
        click_link "edit_item_#{item.id}"
        check "item_illustrator_ids_#{illu2.id}"
        click_button "Save Item"
        expect(page).to have_content "#{item.title}"
        expect(page).to have_content "Illustrators: #{illu1.name}"
        visit illustrators_url
        click_link "show_items_of_illustrator_#{illu1.id}"
        expect(page).to have_content "#{item.title}"
        visit illustrators_url
        click_link "show_items_of_illustrator_#{illu2.id}"
        expect(page).to have_content "#{item.title}"
      end

      it "Removes an illustrator and displays the results" do
        illu1 = FactoryGirl.create(:illustrator)
        illu2 = FactoryGirl.create(:illustrator)
        item = FactoryGirl.create(:item, illustrator_ids: [illu1.id, illu2.id] )
        visit items_url
        click_link "edit_item_#{item.id}"
        uncheck "item_illustrator_ids_#{illu2.id}"
        click_button "Save Item"
        expect(page).to have_content "#{item.title}"
        expect(page).to have_content "Illustrators: #{illu1.name}"
        visit illustrators_url
        click_link "show_items_of_illustrator_#{illu1.id}"
        expect(page).to have_content "#{item.title}"
        visit illustrators_url
        click_link "show_items_of_illustrator_#{illu2.id}"
        expect(page).to_not have_content "#{item.title}"
      end

      it "Changes an item publisher and displays the results" do
        publisher = FactoryGirl.create(:publisher, name: "Iello")
        item = FactoryGirl.create(:item, title: "Great Game", publisher_id: publisher.id)
        secpublisher = FactoryGirl.create(:publisher, name: "Days of Wonder")
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        visit publishers_url
        click_link "show_items_of_publisher_#{publisher.id}"
        expect{
          click_link "edit_item_#{item.id}"
          select  "#{secpublisher.name}", :from => 'item_publisher_id'
          click_button "Save Item"
        }.to_not change(Item,:count)
        within 'h1' do
          expect(page).to have_content "Great Game"
        end
        expect(page).to have_content "Days of Wonder"
        visit publishers_url
        click_link "show_publisher_#{publisher.id}"
        expect(page).to_not have_content "Great Game"
        visit publishers_url
        click_link "show_publisher_#{secpublisher.id}"
        expect(page).to have_content "Great Game"
      end

      it "Changes an item collection and displays the results"  do
        collec = FactoryGirl.create(:collection, name: "Bad Collection")
        item = FactoryGirl.create(:item, title: "Great Game", collection_id: collec.id)
        seccollec = FactoryGirl.create(:collection, name: "Great Collection")

        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'

        visit collections_url
        click_link "show_items_of_collection_#{collec.id}"
        expect{
          click_link "edit_item_#{item.id}"
          select  "#{seccollec.name}", :from => 'item_collection_id'
          click_button "Save Item"
        }.to_not change(Item,:count)
        within 'h1' do
          expect(page).to have_content "Great Game"
        end
        expect(page).to have_content "Great Collection"
        visit collections_url
        click_link "show_collection_#{collec.id}"
        expect(page).to_not have_content "Great Game"
        visit collections_url
        click_link "show_collection_#{seccollec.id}"
        expect(page).to have_content "Great Game"
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

      it "Deletes an item from an author items list" do
        author = FactoryGirl.create(:author, firstname: "Larry", lastname: "Smith")
        item = FactoryGirl.create(:item, title: "Wazabi", author_ids: [author.id])
        item2 = FactoryGirl.create(:item, title: "Hanabi", author_ids: [author.id])
        visit authors_url
        click_link "show_items_of_author_#{author.id}"
        expect{
          click_link "del_item_#{item2.id}"
        }.to change(Item,:count).by(-1)
        expect(page).to have_content "All items"
        expect(page).to_not have_content "Hanabi"
        visit authors_url
        click_link "show_author_#{author.id}"
        expect(page).to_not have_content "Hanabi"
      end

      it "Deletes an item from an illustrator items list" do
        illustrator = FactoryGirl.create(:illustrator, firstname: "Larry", lastname: "Smith")
        item = FactoryGirl.create(:item, title: "Wazabi", illustrator_ids: [illustrator.id])
        item2 = FactoryGirl.create(:item, title: "Hanabi", illustrator_ids: [illustrator.id])
        visit illustrators_url
        click_link "show_items_of_illustrator_#{illustrator.id}"
        expect{
          click_link "del_item_#{item2.id}"
        }.to change(Item,:count).by(-1)
        expect(page).to have_content "All items"
        expect(page).to_not have_content "Hanabi"
        visit illustrators_url
        click_link "show_illustrator_#{illustrator.id}"
        expect(page).to_not have_content "Hanabi"
      end

      it "Deletes an item from a publisher items list" do
        publisher = FactoryGirl.create(:publisher, name: "Iello")
        item = FactoryGirl.create(:item, title: "Wazabi", publisher_id: publisher.id)
        item2 = FactoryGirl.create(:item, title: "Hanabi", publisher_id: publisher.id)
        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'
        visit publishers_url
        click_link "show_items_of_publisher_#{publisher.id}"
        expect{
          click_link "del_item_#{item2.id}"
        }.to change(Item,:count).by(-1)
        expect(page).to have_content "All items"
        expect(page).to_not have_content "Hanabi"
        visit publishers_url
        click_link "show_publisher_#{publisher.id}"
        expect(page).to_not have_content "Hanabi"
      end

      it "Deletes an item from a collection items list" do
        collection = FactoryGirl.create(:collection, name: "Iello")
        item = FactoryGirl.create(:item, title: "Wazabi", collection_id: collection.id)
        item2 = FactoryGirl.create(:item, title: "Hanabi", collection_id: collection.id)

        sign_in_with_donald
        expect(page).to have_link 'Log out'
        expect(page).to have_content 'Team'

        visit collections_url
        click_link "show_items_of_collection_#{collection.id}"
        expect{
          click_link "del_item_#{item2.id}"
        }.to change(Item,:count).by(-1)
        expect(page).to have_content "All items"
        expect(page).to_not have_content "Hanabi"
        visit collections_url
        click_link "show_collection_#{collection.id}"
        expect(page).to_not have_content "Hanabi"
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

end
