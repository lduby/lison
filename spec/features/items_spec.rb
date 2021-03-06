require 'rails_helper'

describe "Items" do

   describe "Manage items" do
      context 'with according rights' do
         before :each do
            @role = FactoryGirl.create(:role, name: 'Team')
            @user = FactoryGirl.create(:user, :donald, roles: Role.where(name: 'Team'))
         end
         it "Adds a new item and displays the results" do
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
            visit items_url
            expect{
               click_link 'New item'
               fill_in 'Title', with: "Example Item"
               click_button "Create Item"
            }.to change(Item,:count).by(1)
            within 'h1' do
               expect(page).to have_content "Example Item"
            end
         end

         it "Adds a new item with an author and displays the results" do
            author = FactoryGirl.create(:author)
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
            visit items_url
            expect{
               click_link 'New item'
               fill_in 'Title', with: "Example Item"
               fill_in 'item_authors_attributes_0_firstname', with: author.firstname
               fill_in 'item_authors_attributes_0_lastname', with: author.lastname
               click_button "Create Item"
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
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
            visit items_url
            expect{
               click_link 'New item'
               fill_in 'Title', with: "Example Item"
               fill_in 'item_illustrators_attributes_0_firstname', with: illustrator.firstname
               fill_in 'item_illustrators_attributes_0_lastname', with: illustrator.lastname
               click_button "Create Item"
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
               fill_in 'item_publisher_attributes_name', with: publisher.name
               click_button "Create Item"
            }.to change(Item,:count).by(1)
            within 'h1' do
               expect(page).to have_content "Example Item"
            end
            expect(page).to have_content("Publisher: #{publisher.name}")
            visit publishers_url
            click_link "show_publisher_#{publisher.id}"
            expect(page).to have_content "#{Item.last.title}"

         end

         it "Adds a new item with a publisher and a collection and displays the results" do
            publisher = FactoryGirl.create(:publisher)
            collection = FactoryGirl.create(:collection, publisher_id: publisher.id)
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
            visit items_url
            expect{
               click_link 'New item'
               fill_in 'Title', with: "Example Item"
               fill_in 'item_publisher_attributes_name', with: publisher.name
               fill_in 'item_collection_attributes_name', with: collection.name
               click_button "Create Item"
            }.to change(Item,:count).by(1)
            within 'h1' do
               expect(page).to have_content "Example Item"
            end
            expect(page).to have_content("Collection: #{collection.name}")
            visit collections_url
            click_link "show_collection_#{collection.id}"
            expect(page).to have_content "#{Item.last.title}"

         end

         it "Adds a new item with an existing collection and displays the results" do
            publisher = FactoryGirl.create(:publisher)
            collection = FactoryGirl.create(:collection, publisher_id: publisher.id)
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
            visit items_url
            expect{
               click_link 'New item'
               fill_in 'Title', with: "Example Item"
               fill_in 'item_collection_attributes_name', with: collection.name
               click_button "Create Item"
            }.to change(Item,:count).by(1)
            within 'h1' do
               expect(page).to have_content "Example Item"
            end
            expect(page).to have_content("Collection: #{collection.name}")
            visit collections_url
            click_link "show_collection_#{collection.id}"
            expect(page).to have_content "#{Item.last.title}"

         end

          it "Prevents to add a new item with an existing collection but without a publisher" do
              collection = FactoryGirl.create(:collection)
              sign_in_with_donald
              expect(page).to have_link 'Log out'
              expect(page).to have_content 'Team'
              visit items_url
              expect{
                  click_link 'New item'
                  fill_in 'Title', with: "Example Item"
                  fill_in 'item_collection_attributes_name', with: collection.name
                  click_button "Create Item"
                  }.to_not change(Item,:count)
              expect(page).to have_content("The collection exists but has no publisher. A publisher has to be filled in.")
              visit collections_url
              click_link "show_collection_#{collection.id}"
              expect(page).to_not have_content "Example Item"

          end

          it "Prevents to add a new item with a new collection but without a publisher" do
              sign_in_with_donald
              expect(page).to have_link 'Log out'
              expect(page).to have_content 'Team'
              visit items_url
              expect{
                  click_link 'New item'
                  fill_in 'Title', with: "Example Item"
                  fill_in 'item_collection_attributes_name', with: 'Pepix'
                  click_button "Create Item"
                  }.to_not change(Item,:count)
              expect(page).to have_content("A new collection needs a publisher to be created.")
              visit collections_url
              expect(page).to_not have_content "Pepix"

          end

         it "Adds a new item with a theme and displays the results" do
            theme = FactoryGirl.create(:theme)
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
            visit items_url
            expect{
               click_link 'New item'
               fill_in 'Title', with: "Example Item"
               fill_in 'item_themes_attributes_0_name', with: theme.name
               click_button "Create Item"
            }.to change(Item,:count).by(1)
            within 'h1' do
               expect(page).to have_content "Example Item"
            end
            expect(page).to have_selector('ul#item_themes_list li', count: 1)
            within 'ul#item_themes_list' do
               expect(page).to have_content("#{theme.name}")
            end
            visit themes_url
            click_link "show_theme_#{theme.id}"
            expect(page).to have_content "#{Item.last.title}"

         end

         it "Adds a new item with a category and displays the results" do
            category = FactoryGirl.create(:category)
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
            visit items_url
            expect{
               click_link 'New item'
               fill_in 'Title', with: "Example Item"
               fill_in 'item_categories_attributes_0_name', with: category.name
               click_button "Create Item"
            }.to change(Item,:count).by(1)
            within 'h1' do
               expect(page).to have_content "Example Item"
            end
            expect(page).to have_selector('ul#item_categories_list li', count: 1)
            within 'ul#item_categories_list' do
               expect(page).to have_content("#{category.name}")
            end
            visit categories_url
            click_link "show_category_#{category.id}"
            expect(page).to have_content "#{Item.last.title}"

         end


         it "Shows an item details" do
            item = FactoryGirl.create(:item, title: "To be viewed item")
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
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
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
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
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
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
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
            visit collections_url
            click_link "show_items_of_collection_#{collection.id}"
            click_link "show_item_#{item.id}"
            within 'h1' do
               expect(page).to have_content "Wazabi"
            end
         end

         it "Shows an item details from a theme items list" do
            theme = FactoryGirl.create(:theme, name: "Iello")
            item = FactoryGirl.create(:item, title: "Wazabi", theme_ids: theme.id)
            item2 = FactoryGirl.create(:item, title: "Hanabi", theme_ids: theme.id)
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
            visit themes_url
            click_link "show_items_of_theme_#{theme.id}"
            click_link "show_item_#{item.id}"
            within 'h1' do
               expect(page).to have_content "Wazabi"
            end
         end

         it "Shows an item details from a category items list" do
            category = FactoryGirl.create(:category, name: "Iello")
            item = FactoryGirl.create(:item, title: "Wazabi", category_ids: category.id)
            item2 = FactoryGirl.create(:item, title: "Hanabi", category_ids: category.id)
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
            visit categories_url
            click_link "show_items_of_category_#{category.id}"
            click_link "show_item_#{item.id}"
            within 'h1' do
               expect(page).to have_content "Wazabi"
            end
         end

         it "Updates an item from an author items list and displays the results" do
            author = FactoryGirl.create(:author, firstname: "Larry", lastname: "Smith")
            item = FactoryGirl.create(:item, title: "Wazabi", author_ids: [author.id])
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
            visit authors_url
            click_link "show_items_of_author_#{author.id}"
            expect{
               click_link "edit_item_#{item.id}"
               fill_in 'Title', with: "Hanabi"
               click_button "Update Item"
            }.to_not change(Item,:count)
            within 'h1' do
               expect(page).to have_content "Hanabi"
            end
         end

         it "Updates an item from an illustrator items list and displays the results" do
            illustrator = FactoryGirl.create(:illustrator, firstname: "Larry", lastname: "Smith")
            item = FactoryGirl.create(:item, title: "Wazabi", illustrator_ids: [illustrator.id])
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
            visit illustrators_url
            click_link "show_items_of_illustrator_#{illustrator.id}"
            expect{
               click_link "edit_item_#{item.id}"
               fill_in 'Title', with: "Hanabi"
               click_button "Update Item"
            }.to_not change(Item,:count)
            within 'h1' do
               expect(page).to have_content "Hanabi"
            end
         end

         it "Updates an item from a publisher items list and displays the results" do
            publisher = FactoryGirl.create(:publisher, name: "Iello")
            item = FactoryGirl.create(:item, title: "Wazabi", publisher_id: publisher.id)
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
            visit publishers_url
            click_link "show_items_of_publisher_#{publisher.id}"
            expect{
               click_link "edit_item_#{item.id}"
               fill_in 'Title', with: "Hanabi"
               click_button "Update Item"
            }.to_not change(Item,:count)
            within 'h1' do
               expect(page).to have_content "Hanabi"
            end
         end

         it "Updates an item from a collection items list and displays the results" do
            collection = FactoryGirl.create(:collection, name: "Iello")
            item = FactoryGirl.create(:item, title: "Wazabi", collection_id: collection.id)
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
            visit collections_url
            click_link "show_items_of_collection_#{collection.id}"
            expect{
               click_link "edit_item_#{item.id}"
               fill_in 'Title', with: "Hanabi"
               click_button "Update Item"
            }.to_not change(Item,:count)
            within 'h1' do
               expect(page).to have_content "Hanabi"
            end
         end

         it "Updates an item from a theme items list and displays the results" do
            theme = FactoryGirl.create(:theme, name: "Iello")
            item = FactoryGirl.create(:item, title: "Wazabi", theme_ids: theme.id)
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
            visit themes_url
            click_link "show_items_of_theme_#{theme.id}"
            expect{
               click_link "edit_item_#{item.id}"
               fill_in 'Title', with: "Hanabi"
               click_button "Update Item"
            }.to_not change(Item,:count)
            within 'h1' do
               expect(page).to have_content "Hanabi"
            end
         end

         it "Updates an item from a category items list and displays the results" do
            category = FactoryGirl.create(:category, name: "Iello")
            item = FactoryGirl.create(:item, title: "Wazabi", category_ids: category.id)
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
            visit categories_url
            click_link "show_items_of_category_#{category.id}"
            expect{
               click_link "edit_item_#{item.id}"
               fill_in 'Title', with: "Hanabi"
               click_button "Update Item"
            }.to_not change(Item,:count)
            within 'h1' do
               expect(page).to have_content "Hanabi"
            end
         end

         it "Updates an item and displays the results" do
            item = FactoryGirl.create(:item, title: "To be updated item")
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
            visit items_url
            expect{
               click_link "edit_item_#{item.id}"
               fill_in 'Title', with: "Updated Item"
               click_button "Update Item"
            }.to_not change(Item,:count)
            within 'h1' do
               expect(page).to have_content "Updated Item"
            end

         end

         it "Adds an author and displays the results" do
            author1 = FactoryGirl.create(:author)
            author2 = FactoryGirl.create(:author)
            item = FactoryGirl.create(:item, author_ids: [author1.id] )
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
            visit items_url
            click_link "edit_item_#{item.id}"
            fill_in 'item_authors_attributes_1_firstname', with: author2.firstname
            fill_in 'item_authors_attributes_1_lastname', with: author2.lastname
            click_button "Update Item"
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
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
            visit items_url
            click_link "edit_item_#{item.id}"
            check "item_authors_attributes_1__destroy"
            click_button "Update Item"
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
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
            visit items_url
            click_link "edit_item_#{item.id}"
            fill_in 'item_illustrators_attributes_1_firstname', with: illu2.firstname
            fill_in 'item_illustrators_attributes_1_lastname', with: illu2.lastname
            click_button "Update Item"
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
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
            visit items_url
            click_link "edit_item_#{item.id}"
            check "item_illustrators_attributes_1__destroy"
            click_button "Update Item"
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
               fill_in 'item_publisher_attributes_name', with: secpublisher.name
               click_button "Update Item"
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
               fill_in 'item_collection_attributes_name', with: seccollec.name
               click_button "Update Item"
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

         it "Adds a theme and displays the resuts" do
            th1 = FactoryGirl.create(:theme)
            th2 = FactoryGirl.create(:theme, name: "Theme2")
            item = FactoryGirl.create(:item, theme_ids: [th1.id] )
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
            visit items_url
            click_link "edit_item_#{item.id}"
            fill_in 'item_themes_attributes_1_name', with: th2.name
            click_button "Update Item"
            expect(page).to have_content "#{item.title}"
            expect(page).to have_selector('ul#item_themes_list li', count: 2)
            within 'ul#item_themes_list' do
               expect(page).to have_content "#{th1.name}"
               expect(page).to have_content "#{th2.name}"
            end
            visit themes_url
            click_link "show_items_of_theme_#{th1.id}"
            expect(page).to have_content "#{item.title}"
            visit themes_url
            click_link "show_items_of_theme_#{th2.id}"
            expect(page).to have_content "#{item.title}"
         end

         it "Removes a theme and displays the results" do
            th1 = FactoryGirl.create(:theme)
            th2 = FactoryGirl.create(:theme)
            item = FactoryGirl.create(:item, theme_ids: [th1.id, th2.id] )
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
            visit items_url
            click_link "edit_item_#{item.id}"
            check "item_themes_attributes_1__destroy"
            click_button "Update Item"
            expect(page).to have_content "#{item.title}"
            expect(page).to have_selector('ul#item_themes_list li', count: 1)
            within 'ul#item_themes_list' do
               expect(page).to have_content "#{th1.name}"
               expect(page).to_not have_content "#{th2.name}"
            end
            visit themes_url
            click_link "show_items_of_theme_#{th1.id}"
            expect(page).to have_content "#{item.title}"
            visit themes_url
            click_link "show_items_of_theme_#{th2.id}"
            expect(page).to_not have_content "#{item.title}"
         end

         it "Adds a category and displays the resuts" do
            cat1 = FactoryGirl.create(:category)
            cat2 = FactoryGirl.create(:category)
            item = FactoryGirl.create(:item, category_ids: [cat1.id] )
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
            visit items_url
            click_link "edit_item_#{item.id}"
            fill_in 'item_categories_attributes_1_name', with: cat2.name
            click_button "Update Item"
            expect(page).to have_content "#{item.title}"
            expect(page).to have_selector('ul#item_categories_list li', count: 2)
            within 'ul#item_categories_list' do
               expect(page).to have_content "#{cat1.name}"
               expect(page).to have_content "#{cat2.name}"
            end
            visit categories_url
            click_link "show_items_of_category_#{cat1.id}"
            expect(page).to have_content "#{item.title}"
            visit categories_url
            click_link "show_items_of_category_#{cat2.id}"
            expect(page).to have_content "#{item.title}"
         end

         it "Removes a category and displays the results" do
            cat1 = FactoryGirl.create(:category)
            cat2 = FactoryGirl.create(:category)
            item = FactoryGirl.create(:item, category_ids: [cat1.id, cat2.id] )
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
            visit items_url
            click_link "edit_item_#{item.id}"
            check "item_categories_attributes_1__destroy"
            click_button "Update Item"
            expect(page).to have_content "#{item.title}"
            expect(page).to have_selector('ul#item_categories_list li', count: 1)
            within 'ul#item_categories_list' do
               expect(page).to have_content "#{cat1.name}"
               expect(page).to_not have_content "#{cat2.name}"
            end
            visit categories_url
            click_link "show_items_of_category_#{cat1.id}"
            expect(page).to have_content "#{item.title}"
            visit categories_url
            click_link "show_items_of_category_#{cat2.id}"
            expect(page).to_not have_content "#{item.title}"
         end


         it "Deletes an item" do
            item = FactoryGirl.create(:item, title: "To be deleted item")
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
            visit items_path
            expect{
               click_link "del_item_#{item.id}"
            }.to change(Item,:count).by(-1)
            expect(page).to have_content "Browse items"
            expect(page).to_not have_content "To be deleted item"
         end

         it "Deletes an item from an author items list" do
            author = FactoryGirl.create(:author, firstname: "Larry", lastname: "Smith")
            item = FactoryGirl.create(:item, title: "Wazabi", author_ids: [author.id])
            item2 = FactoryGirl.create(:item, title: "Hanabi", author_ids: [author.id])
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
            visit authors_url
            click_link "show_items_of_author_#{author.id}"
            expect{
               click_link "del_item_#{item2.id}"
            }.to change(Item,:count).by(-1)
            expect(page).to have_content "Browse items"
            expect(page).to_not have_content "Hanabi"
            visit authors_url
            click_link "show_author_#{author.id}"
            expect(page).to_not have_content "Hanabi"
         end

         it "Deletes an item from an illustrator items list" do
            illustrator = FactoryGirl.create(:illustrator, firstname: "Larry", lastname: "Smith")
            item = FactoryGirl.create(:item, title: "Wazabi", illustrator_ids: [illustrator.id])
            item2 = FactoryGirl.create(:item, title: "Hanabi", illustrator_ids: [illustrator.id])
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
            visit illustrators_url
            click_link "show_items_of_illustrator_#{illustrator.id}"
            expect{
               click_link "del_item_#{item2.id}"
            }.to change(Item,:count).by(-1)
            expect(page).to have_content "Browse items"
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
            expect(page).to have_content "Browse items"
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
            expect(page).to have_content "Browse items"
            expect(page).to_not have_content "Hanabi"
            visit collections_url
            click_link "show_collection_#{collection.id}"
            expect(page).to_not have_content "Hanabi"
         end

         it "Deletes an item from a theme items list" do
            theme = FactoryGirl.create(:theme, name: "Theme")
            item = FactoryGirl.create(:item, title: "Wazabi", theme_ids: theme.id)
            item2 = FactoryGirl.create(:item, title: "Hanabi", theme_ids: theme.id)

            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'

            visit themes_url
            click_link "show_items_of_theme_#{theme.id}"
            expect{
               click_link "del_item_#{item2.id}"
            }.to change(Item,:count).by(-1)
            expect(page).to have_content "Browse items"
            expect(page).to_not have_content "Hanabi"
            visit themes_url
            click_link "show_theme_#{theme.id}"
            expect(page).to_not have_content "Hanabi"
         end

         it "Deletes an item from a category items list" do
            category = FactoryGirl.create(:category, name: "category")
            item = FactoryGirl.create(:item, title: "Wazabi", category_ids: category.id)
            item2 = FactoryGirl.create(:item, title: "Hanabi", category_ids: category.id)

            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'

            visit categories_url
            click_link "show_items_of_category_#{category.id}"
            expect{
               click_link "del_item_#{item2.id}"
            }.to change(Item,:count).by(-1)
            expect(page).to have_content "Browse items"
            expect(page).to_not have_content "Hanabi"
            visit categories_url
            click_link "show_category_#{category.id}"
            expect(page).to_not have_content "Hanabi"
         end

         it "Deletes an item with js dialog", js: true do
            DatabaseCleaner.clean
            item = FactoryGirl.create(:item, title: "To be deleted item")
            @role = FactoryGirl.create(:role, name: 'Team')
            @user = FactoryGirl.create(:user, :donald, roles: Role.where(name: 'Team'))
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Team'
            visit items_path
            sleep 1
            expect{
               click_link "del_item_#{item.id}"
               sleep 1
               alert = page.driver.browser.switch_to.alert
               alert.accept
               sleep 1
            }.to change(Item,:count).by(-1)
            expect(page).to have_content "Browse items"
            expect(page).to_not have_content "To be deleted item"
         end
      end


      context 'with basic rights' do
         before :each do
            @role = FactoryGirl.create(:role, name: 'Member')
            @user = FactoryGirl.create(:user, :donald, roles: Role.where(name: 'Member'))
         end

         it "Prevents from adding a new item"
         it "Prevents from adding a new item with an author"
         it "Prevents from adding a new item with an illustrator"
         it "Prevents from adding a new item with a publisher"
         it "Prevents from adding a new item with a collection"
         it "Prevents from adding a new item with a theme"
         it "Prevents from adding a new item with a category"
         it "Shows an item details" do
            item = FactoryGirl.create(:item, title: "To be viewed item")
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Member'
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
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Member'
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
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Member'
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
            expect(page).to have_content 'Member'
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
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Member'
            visit collections_url
            click_link "show_items_of_collection_#{collection.id}"
            click_link "show_item_#{item.id}"
            within 'h1' do
               expect(page).to have_content "Wazabi"
            end
         end

         it "Shows an item details from a theme items list" do
            theme = FactoryGirl.create(:theme, name: "Iello")
            item = FactoryGirl.create(:item, title: "Wazabi", theme_ids: theme.id)
            item2 = FactoryGirl.create(:item, title: "Hanabi", theme_ids: theme.id)
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Member'
            visit themes_url
            click_link "show_items_of_theme_#{theme.id}"
            click_link "show_item_#{item.id}"
            within 'h1' do
               expect(page).to have_content "Wazabi"
            end
         end

         it "Shows an item details from a category items list" do
            category = FactoryGirl.create(:category, name: "Iello")
            item = FactoryGirl.create(:item, title: "Wazabi", category_ids: category.id)
            item2 = FactoryGirl.create(:item, title: "Hanabi", category_ids: category.id)
            sign_in_with_donald
            expect(page).to have_link 'Log out'
            expect(page).to have_content 'Member'
            visit categories_url
            click_link "show_items_of_category_#{category.id}"
            click_link "show_item_#{item.id}"
            within 'h1' do
               expect(page).to have_content "Wazabi"
            end
         end

         it "Prevents from updating an item from an author items list"
         it "Prevents from updating an item from an illustrator items list"
         it "Prevents from updating an item from a publisher items list"
         it "Prevents from updating an item from a collection items list"
         it "Prevents from updating an item from a theme items list"
         it "Prevents from updating an item from a category items list"
         it "Prevents from updating an item"
         it "Prevents from adding an author"
         it "Prevents from removing an author"
         it "Prevents from adding an illustrator"
         it "Prevents from removing an illustrator"
         it "Prevents from changing an item publisher"
         it "Prevents from changing an item collection"
         it "Prevents from adding a theme"
         it "Prevents from removing a theme"
         it "Prevents from adding a category"
         it "Prevents from removing a category"
         it "Prevents from deleting an item"
         it "Prevents from deleting an item from an author items list"
         it "Prevents from deleting an item from an illustrator items list"
         it "Prevents from deleting an item from a publisher items list"
         it "Prevents from deleting an item from a collection items list"
         it "Prevents from deleting an item from a theme items list"
         it "Prevents from deleting an item from a category items list"

      end

      context 'with no rights' do

         it "Prevents from adding a new item"
         it "Prevents from adding a new item with an author"
         it "Prevents from adding a new item with an illustrator"
         it "Prevents from adding a new item with a publisher"
         it "Prevents from adding a new item with a collection"
         it "Prevents from adding a new item with a theme"
         it "Prevents from adding a new item with a category"
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

         it "Shows an item details from a theme items list" do
            theme = FactoryGirl.create(:theme, name: "Iello")
            item = FactoryGirl.create(:item, title: "Wazabi", theme_ids: theme.id)
            item2 = FactoryGirl.create(:item, title: "Hanabi", theme_ids: theme.id)
            visit themes_url
            click_link "show_items_of_theme_#{theme.id}"
            click_link "show_item_#{item.id}"
            within 'h1' do
               expect(page).to have_content "Wazabi"
            end
         end

         it "Shows an item details from a category items list" do
            category = FactoryGirl.create(:category, name: "Iello")
            item = FactoryGirl.create(:item, title: "Wazabi", category_ids: category.id)
            item2 = FactoryGirl.create(:item, title: "Hanabi", category_ids: category.id)
            visit categories_url
            click_link "show_items_of_category_#{category.id}"
            click_link "show_item_#{item.id}"
            within 'h1' do
               expect(page).to have_content "Wazabi"
            end
         end

         it "Prevents from updating an item from an author items list"
         it "Prevents from updating an item from an illustrator items list"
         it "Prevents from updating an item from a publisher items list"
         it "Prevents from updating an item from a collection items list"
         it "Prevents from updating an item from a theme items list"
         it "Prevents from updating an item from a category items list"
         it "Prevents from updating an item"
         it "Prevents from adding an author"
         it "Prevents from removing an author"
         it "Prevents from adding an illustrator"
         it "Prevents from removing an illustrator"
         it "Prevents from changing an item publisher"
         it "Prevents from changing an item collection"
         it "Prevents from adding a theme"
         it "Prevents from removing a theme"
         it "Prevents from adding a category"
         it "Prevents from removing a category"
         it "Prevents from deleting an item"
         it "Prevents from deleting an item from an author items list"
         it "Prevents from deleting an item from an illustrator items list"
         it "Prevents from deleting an item from a publisher items list"
         it "Prevents from deleting an item from a collection items list"
         it "Prevents from deleting an item from a theme items list"
         it "Prevents from deleting an item from a category items list"

      end
   end
end
