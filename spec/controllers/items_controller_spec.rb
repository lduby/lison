require 'rails_helper'

describe ItemsController, type: :controller do

   before :each do

      @ability = Object.new
      @ability.extend(CanCan::Ability)

   end

   describe "GET #index" do
      it "populates an array of items" do
         item = FactoryGirl.create(:item)
         get :index
         expect(assigns(:items)).to eq([item])
      end
      it "renders the items :index view" do
         get :index
         expect(response).to render_template :index
      end
   end

   describe "GET #list" do
      it "populates an array of items associated to an author" do
         author = FactoryGirl.create(:author)
         item = FactoryGirl.create(:item, author_ids: [author.id])
         item2 = FactoryGirl.create(:item, author_ids: [])
         get :index
         expect(author.items).to eq([item])
         expect(author.items).to_not include(item2)
      end
      it "renders the items :list view when an author is specified" do
         author = FactoryGirl.create(:author)
         item = FactoryGirl.create(:item, author_ids: [author.id])
         item2 = FactoryGirl.create(:item, author_ids: [])
         @ability.can :manage, :all
         get :list, author_id: author.id
         expect(response).to render_template :list
      end
      it "populates an array of items associated to an illustrator" do
         illustrator = FactoryGirl.create(:illustrator)
         item = FactoryGirl.create(:item, illustrator_ids: [illustrator.id])
         item2 = FactoryGirl.create(:item, illustrator_ids: [])
         get :index
         expect(illustrator.items).to eq([item])
         expect(illustrator.items).to_not include(item2)
      end
      it "renders the items :list view when an illustrator is specified" do
         illustrator = FactoryGirl.create(:illustrator)
         item = FactoryGirl.create(:item, illustrator_ids: [illustrator.id])
         item2 = FactoryGirl.create(:item, illustrator_ids: [])
         get :list, illustrator_id: illustrator.id
         expect(response).to render_template :list
      end
      it "populates an array of items associated to a publisher" do
         publisher = FactoryGirl.create(:publisher)
         item = FactoryGirl.create(:item, publisher_id: publisher.id)
         item2 = FactoryGirl.create(:item)
         get :index
         expect(publisher.items).to eq([item])
         expect(publisher.items).to_not include(item2)
      end
      it "renders the items :list view when a publisher is specified" do
         publisher = FactoryGirl.create(:publisher)
         item = FactoryGirl.create(:item, publisher_id: publisher.id)
         item2 = FactoryGirl.create(:item)
         get :list, publisher_id: publisher.id
         expect(response).to render_template :list
      end
      it "populates an array of items associated to a collection" do
         collection = FactoryGirl.create(:collection)
         item = FactoryGirl.create(:item, collection_id: collection.id)
         item2 = FactoryGirl.create(:item)
         get :index
         expect(collection.items).to eq([item])
         expect(collection.items).to_not include(item2)
      end
      it "renders the items :list view when a collection is specified" do
         collection = FactoryGirl.create(:collection)
         item = FactoryGirl.create(:item, collection_id: collection.id)
         item2 = FactoryGirl.create(:item)
         get :list, collection_id: collection.id
         expect(response).to render_template :list
      end
      it "populates an array of items associated to a theme" do
         theme = FactoryGirl.create(:theme)
         item = FactoryGirl.create(:item, theme_ids: [theme.id])
         item2 = FactoryGirl.create(:item, theme_ids: [])
         get :index
         expect(theme.items).to eq([item])
         expect(theme.items).to_not include(item2)
      end
      it "renders the items :list view when a theme is specified" do
         theme = FactoryGirl.create(:theme)
         item = FactoryGirl.create(:item, theme_ids: [theme.id])
         item2 = FactoryGirl.create(:item, theme_ids: [])
         get :list, theme_id: theme.id
         expect(response).to render_template :list
      end
      it "populates an array of items associated to a category" do
         category = FactoryGirl.create(:category)
         item = FactoryGirl.create(:item, category_ids: [category.id])
         item2 = FactoryGirl.create(:item, category_ids: [])
         get :index
         expect(category.items).to eq([item])
         expect(category.items).to_not include(item2)
      end
      it "renders the items :list view when a category is specified" do
         category = FactoryGirl.create(:category)
         item = FactoryGirl.create(:item, category_ids: [category.id])
         item2 = FactoryGirl.create(:item, category_ids: [])
         get :list, category_id: category.id
         expect(response).to render_template :list
      end
   end

   describe "GET #show" do
      it "assigns the requested item to @item" do
         item = FactoryGirl.create(:item)
         @controller.stub(:current_ability).and_return(@ability)
         @ability.can :read, item
         get :show, id: item
         expect(assigns(:item)).to eq(item)
      end
      it "renders the item :show template" do
         @controller.stub(:current_ability).and_return(@ability)
         @ability.can :read, Item
         get :show, id: FactoryGirl.create(:item)
         expect(response).to render_template :show
      end
   end

   describe "GET #new" do
      it "assigns a new Item to @item" do
         @controller.stub(:current_ability).and_return(@ability)
         @ability.can :create, Item
         get :new
         expect(assigns(:item)).to be_a_new(Item)
         # expect(assigns(:business).addresses.first).to be_a_new(Address)
      end
      it "populates an array of authors" do
         author = FactoryGirl.create(:author)
         @controller.stub(:current_ability).and_return(@ability)
         @ability.can :create, Item
         get :new
         expect(assigns(:authors)).to eq([author])
      end
      it "populates an array of illustrators" do
         illustrator = FactoryGirl.create(:illustrator)
         @controller.stub(:current_ability).and_return(@ability)
         @ability.can :create, Item
         get :new
         expect(assigns(:illustrators)).to eq([illustrator])
      end
      it "populates an array of publishers" do
         publisher = FactoryGirl.create(:publisher)
         @controller.stub(:current_ability).and_return(@ability)
         @ability.can :create, Item
         get :new
         expect(assigns(:publishers)).to eq([publisher])
      end
      it "populates an array of collections" do
         collection = FactoryGirl.create(:collection)
         @controller.stub(:current_ability).and_return(@ability)
         @ability.can :create, Item
         get :new
         expect(assigns(:collections)).to eq([collection])
      end
      it "populates an array of themes" do
         theme = FactoryGirl.create(:theme)
         @controller.stub(:current_ability).and_return(@ability)
         @ability.can :create, Item
         get :new
         expect(assigns(:themes)).to eq([theme])
      end
      it "populates an array of categories" do
         category = FactoryGirl.create(:category)
         @controller.stub(:current_ability).and_return(@ability)
         @ability.can :create, Item
         get :new
         expect(assigns(:categories)).to eq([category])
      end
      it "renders the item :new template" do
         @controller.stub(:current_ability).and_return(@ability)
         @ability.can :create, Item
         get :new
         expect(response).to render_template :new
      end
   end

   describe "POST #create" do
      context "with valid attributes" do
         it "saves the new item in the database" do
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :create, Item
            expect{
               post :create, item: FactoryGirl.attributes_for(:item)
            }.to change(Item,:count).by(1)
         end
         it "redirects to the items :index page" do
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :create, Item
            post :create, item: FactoryGirl.attributes_for(:item)
            expect(response).to redirect_to Item.last
         end
         it "associates authors to the item" do
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :create, Item
            author = FactoryGirl.create(:author)
            post :create, item: FactoryGirl.attributes_for(:item, author_ids: [author.id])
            expect(assigns(:item).authors).to eq([author])
         end
         it "associates illustrators to the item" do
            illustrator = FactoryGirl.create(:illustrator)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :create, Item
            post :create, item: FactoryGirl.attributes_for(:item, illustrator_ids: [illustrator.id])
            expect(assigns(:item).illustrators).to eq([illustrator])
         end
         it "associates a publisher to the item" do
            publisher = FactoryGirl.create(:publisher)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :create, Item
            post :create, item: FactoryGirl.attributes_for(:item, publisher_id: publisher.id)
            expect(assigns(:item).publisher).to eq(publisher)
            expect(publisher.items).to include(assigns(:item))
         end
         it "associates a collection to the item" do
            collection = FactoryGirl.create(:collection)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :create, Item
            post :create, item: FactoryGirl.attributes_for(:item, collection_id: collection.id)
            expect(assigns(:item).collection).to eq(collection)
            expect(collection.items).to include(assigns(:item))
         end
         it "associates themes to the item" do
            theme = FactoryGirl.create(:theme)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :create, Item
            post :create, item: FactoryGirl.attributes_for(:item, theme_ids: [theme.id])
            expect(assigns(:item).themes).to eq([theme])
         end
         it "associates categories to the item" do
            category = FactoryGirl.create(:category)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :create, Item
            post :create, item: FactoryGirl.attributes_for(:item, category_ids: [category.id])
            expect(assigns(:item).categories).to eq([category])
         end
      end

      context "with invalid attributes" do
         it "does not save the new item in the database" do
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :create, Item
            expect{
               post :create, item: FactoryGirl.attributes_for(:invalid_item)
            }.to_not change(Item,:count)
         end
         it "re-renders the item :new template" do
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :create, Item
            post :create, item: FactoryGirl.attributes_for(:invalid_item)
            expect(response).to render_template :new
         end
      end

      context "with nested attributes" do
         it "creates an item with an existing publisher and an existing collection of the publisher" do
            publisher = FactoryGirl.create(:publisher)
            collection = FactoryGirl.create(:collection, publisher_id: publisher.id)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :create, Item
            post :create, item: FactoryGirl.attributes_for(:item, publisher_attributes: {"name"=>publisher.name, "about"=>publisher.about}, collection_attributes: {"name"=>collection.name, "about"=>collection.about})
            expect(assigns(:item).publisher.id).to eq(publisher.id)
            expect(assigns(:item).collection.id).to eq(collection.id)
         end
         it "does not create an item with an existing publisher and an existing collection associated to another publisher" do
            pub1 = FactoryGirl.create(:publisher)
            pub2 = FactoryGirl.create(:publisher)
            coll = FactoryGirl.create(:collection, publisher_id: pub2.id)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :create, Item
            expect{
               post :create, item: FactoryGirl.attributes_for(:item, publisher_attributes: {"name"=>pub1.name, "about"=>pub1.about}, collection_attributes: {"name"=>coll.name, "about"=>coll.about})
            }.to_not change(Item,:count)
         end
         it "creates an item with an existing publisher and a new collection" do
            publisher = FactoryGirl.create(:publisher)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :create, Item
            post :create, item: FactoryGirl.attributes_for(:item, publisher_attributes: {"name"=>publisher.name, "about"=>publisher.about}, collection_attributes: {"name"=>"Great Collection", "about"=>"Description of the great collection"})
            expect(assigns(:item).publisher.id).to eq(publisher.id)
            expect(assigns(:item).collection.name).to eq("Great Collection")
            expect(assigns(:item).collection.publisher).to_not be_nil
            expect(assigns(:item).collection.publisher.id).to eq(publisher.id)
         end
         it "creates an item with an existing publisher and no collection" do
            publisher = FactoryGirl.create(:publisher)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :create, Item
            post :create, item: FactoryGirl.attributes_for(:item, publisher_attributes: {"name"=>publisher.name, "about"=>publisher.about})
            expect(assigns(:item).publisher.id).to eq(publisher.id)
            expect(assigns(:item).collection).to be_nil
         end
         # KO
         it "creates an item with a new publisher and an existing collection without publisher" do
            collection = FactoryGirl.create(:collection)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :create, Item
            post :create, item: FactoryGirl.attributes_for(:item, publisher_attributes: {"name"=>"Great Publisher", "about"=>"Description of the great publisher"}, collection_attributes: {"name"=>collection.name, "about"=>collection.about})
            expect(assigns(:item).collection.id).to eq(collection.id)
            expect(assigns(:item).publisher.name).to eq("Great Publisher")
            expect(assigns(:item).collection.publisher).to_not be_nil
            expect(assigns(:item).collection.publisher.name).to eq("Great Publisher")
         end
         it "does not create an item with a new publisher and an existing collection associated to another publisher" do
            pub = FactoryGirl.create(:publisher)
            coll = FactoryGirl.create(:collection, publisher_id: pub.id)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :create, Item
            expect{
               post :create, item: FactoryGirl.attributes_for(:item, publisher_attributes: {"name"=>pub.name.concat(" awesome"), "about"=>""}, collection_attributes: {"name"=>coll.name, "about"=>coll.about})
            }.to_not change(Item,:count)
         end
         it "creates an item with a new publisher and a new collection" do
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :create, Item
            post :create, item: FactoryGirl.attributes_for(:item, publisher_attributes: {"name"=>"Great Publisher", "about"=>""}, collection_attributes: {"name"=>"Great Collection", "about"=>""})
            expect(assigns(:item).publisher.name).to eq("Great Publisher")
            expect(assigns(:item).collection.name).to eq("Great Collection")
            expect(assigns(:item).collection.publisher).to_not be_nil
            expect(assigns(:item).publisher.id).to eq(assigns(:item).collection.publisher.id)
         end
         it "creates an item with a new publisher and no collection" do
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :create, Item
            post :create, item: FactoryGirl.attributes_for(:item, publisher_attributes: {"name"=>"Great Publisher", "about"=>""})
            expect(assigns(:item).publisher.name).to eq("Great Publisher")
            expect(assigns(:item).collection).to be_nil
         end
         # KO
         it "creates an item with no publisher and an existing collection linked to a publisher" do
            pub = FactoryGirl.create(:publisher)
            coll = FactoryGirl.create(:collection, publisher_id: pub.id)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :create, Item
            post :create, item: FactoryGirl.attributes_for(:item, collection_attributes: {"name"=>coll.name, "about"=>coll.about})
            expect(assigns(:item).collection.id).to eq(coll.id)
            expect(assigns(:item).publisher).to_not be_nil
            expect(assigns(:item).publisher.id).to eq(coll.publisher.id)
         end
         it "does not create an item with no publisher and an existing collection not linked to a publisher" do
            coll = FactoryGirl.create(:collection)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :create, Item
            expect{
               post :create, item: FactoryGirl.attributes_for(:item, collection_attributes: {"name"=>coll.name, "about"=>coll.about})
            }.to_not change(Item,:count)
         end
         # KO
         it "does not create an item with no publisher and a new collection" do
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :create, Item
            expect{
               post :create, item: FactoryGirl.attributes_for(:item, collection_attributes: {"name"=>"Great Collection", "about"=>""})
            }.to_not change(Item,:count)
         end
         it "creates an item with no publisher and no collection" do
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :create, Item
            post :create, item: FactoryGirl.attributes_for(:item, publisher_attributes: {"name"=>"", "about"=>""}, collection_attributes: {"name"=>"", "about"=>""})
            expect(assigns(:item).publisher).to be_nil
            expect(assigns(:item).collection).to be_nil
         end


      end
   end

   describe 'PUT #update' do
      before :each do
         @auth = FactoryGirl.create(:author)
         @illust = FactoryGirl.create(:illustrator)
         @pub = FactoryGirl.create(:publisher)
         @coll = FactoryGirl.create(:collection, publisher_id: @pub.id)
         @th = FactoryGirl.create(:theme)
         @cat = FactoryGirl.create(:category)
         @item = FactoryGirl.create(:item, title: "Test Item")
          @item.authors << @auth
          @item.illustrators << @illust
          @pub.collections << @coll
          @coll.items << @item
          @pub.items << @item
          @item.themes << @th
          @item.categories << @cat
          puts @item.inspect
      end

      context "with valid attributes" do
         it "locates the requested @item" do
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item)
            expect(assigns(:item)).to eq(@item)
         end

         it "changes @item's attributes" do
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item,
            item: FactoryGirl.attributes_for(:item, title: "Updated test item")
            @item.reload
            expect(@item.title).to eq("Updated test item")
         end

         it "adds an author" do
            author = FactoryGirl.create(:author)
            authors = @item.author_ids
            authors_nb=authors.size
            authors << author.id
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, author_ids: authors)
            @item.reload
            expect(@item.authors.count).to eq(authors_nb+1)
            expect(@item.authors).to include(author)
         end

         it "adds an illustrator" do
            illustrator = FactoryGirl.create(:illustrator)
            illustrators = @item.illustrator_ids
            illustrators_nb = illustrators.size
            illustrators << illustrator.id
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, illustrator_ids: illustrators)
            @item.reload
            expect(@item.illustrators.count).to eq(illustrators_nb+1)
            expect(@item.illustrators).to include(illustrator)
         end

         it "deletes an author"  do
            author = @item.authors.last
            authors = @item.author_ids
            authors_nb=authors.size
            authors.delete(author.id)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, author_ids: authors)
            @item.reload
            expect(@item.authors.count).to eq(authors_nb-1)
            expect(@item.authors).to_not include(author)
         end

         it "deletes an illustrator"  do
            illustrator = @item.illustrators.last
            illustrators = @item.illustrator_ids
            illustrators_nb=illustrators.size
            illustrators.delete(illustrator.id)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, illustrator_ids: illustrators)
            @item.reload
            expect(@item.illustrators.count).to eq(illustrators_nb-1)
            expect(@item.illustrators).to_not include(illustrator)
         end

         # KO
         it "changes the publisher" do
            pub2 = FactoryGirl.create(:publisher)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_id: pub2.id)
            @item.reload
            expect(@item.publisher).to eq(pub2)
            expect(@item.collection).to eq(nil)
         end

         it "changes the collection"  do
            coll2 = FactoryGirl.create(:collection, publisher_id: @pub.id)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, collection_id: coll2.id)
            @item.reload
            expect(@item.collection).to eq(coll2)
         end

         it "adds a theme" do
            theme = FactoryGirl.create(:theme)
            themes = @item.theme_ids
            themes_nb = themes.size
            themes << theme.id
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, theme_ids: themes)
            @item.reload
            expect(@item.themes.count).to eq(themes_nb+1)
            expect(@item.themes).to include(theme)
         end

         it "deletes a theme"  do
            theme = @item.themes.last
            themes = @item.theme_ids
            themes_nb=themes.size
            themes.delete(theme.id)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, theme_ids: themes)
            @item.reload
            expect(@item.themes.count).to eq(themes_nb-1)
            expect(@item.themes).to_not include(theme)
         end


         it "adds a category" do
            category = FactoryGirl.create(:category)
            categories = @item.category_ids
            categories_nb = categories.size
            categories << category.id
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, category_ids: categories)
            @item.reload
            expect(@item.categories.count).to eq(categories_nb+1)
            expect(@item.categories).to include(category)
         end

         it "deletes a category"  do
            category = @item.categories.last
            categories = @item.category_ids
            categories_nb=categories.size
            categories.delete(category.id)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, category_ids: categories)
            @item.reload
            expect(@item.categories.count).to eq(categories_nb-1)
            expect(@item.categories).to_not include(category)
         end

         it "redirects to the updated item" do
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item)
            expect(response).to redirect_to @item
         end
      end

      context "with invalid attributes" do
         it "locates the requested @item" do
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:invalid_item)
            expect(assigns(:item)).to eq(@item)
         end

         it "does not change @item's attributes" do
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, title: nil)
            @item.reload
            expect(@item.title).to eq("Test Item")
         end

         it "re-renders the edit method" do
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:invalid_item)
            expect(response).to render_template :edit
         end
      end

      context "with nested attributes" do

         it "updates an item having a publisher and a collection by changing the publisher by an existing one and changing the collection to one of the new publisher" do
            puts "before update: #{@item.inspect}"
            publisher = FactoryGirl.create(:publisher)
            collection = FactoryGirl.create(:collection, publisher_id: publisher.id)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_id: @pub.id, collection_id: @coll.id, publisher_attributes: {"name"=>publisher.name, "about"=>publisher.about, "id"=>@pub.id}, collection_attributes: {"name"=>collection.name, "about"=>collection.about, "id"=>@coll.id})
            @item.reload
            expect(@item.publisher.id).to eq(publisher.id)
            expect(@item.collection.id).to eq(collection.id)
            expect(@item.collection.publisher.id).to eq(publisher.id)
         end

         it "does not update an item having a publisher and a collection by changing the publisher by an existing one and changing the collection to one which does not belong to the new publisher" do
            publisher = FactoryGirl.create(:publisher)
            otherpublisher = FactoryGirl.create(:publisher)
            collection = FactoryGirl.create(:collection, publisher_id: otherpublisher.id)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_id: @pub.id, collection_id: @coll.id, publisher_attributes: {"name"=>publisher.name, "about"=>publisher.about, "id"=>@pub.id}, collection_attributes: {"name"=>collection.name, "about"=>collection.about, "id"=>@coll.id})
            @item.reload
            expect(@item.publisher.id).to eq(@pub.id)
            expect(@item.collection.id).to eq(@coll.id)
            expect(response).to render_template :edit
         end

         it "updates an item having a publisher and a collection by changing the publisher by an existing one and changing the collection to a new one" do
            publisher = FactoryGirl.create(:publisher)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_id: @pub.id, collection_id: @coll.id, publisher_attributes: {"name"=>publisher.name, "about"=>publisher.about, "id"=>@pub.id}, collection_attributes: {"name"=>"Collection1", "about"=>"", "id"=>@coll.id})
            @item.reload
            expect(@item.publisher.id).to eq(publisher.id)
             expect(@item.collection.name).to eq("Collection1")
            expect(@item.collection.publisher.id).to eq(publisher.id)
         end

         it "does not update an item having a publisher and a collection by changing the publisher by an existing one and keeping the collection unchanged" do
            publisher = FactoryGirl.create(:publisher)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_id: @pub.id, collection_id: @coll.id, publisher_attributes: {"name"=>publisher.name, "about"=>publisher.about, "id"=>@pub.id}, collection_attributes: {"name"=>@coll.name, "about"=>@coll.about, "id"=>@coll.id} )
            @item.reload
            expect(@item.publisher.id).to eq(@pub.id)
            expect(@item.collection.id).to eq(@coll.id)
            expect(response).to render_template :edit
         end

         it "does not update an item having a publisher and a collection by changing the publisher by a new one and changing the collection to one which belongs to an existing publisher" do
            otherpublisher = FactoryGirl.create(:publisher)
            collection = FactoryGirl.create(:collection, publisher_id: otherpublisher.id)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_id: @pub.id, collection_id: @coll.id, publisher_attributes: {"name"=>"Publisher1", "about"=>"", "id"=>@pub.id}, collection_attributes: {"name"=>collection.name, "about"=>collection.about, "id"=>@coll.id})
            @item.reload
            expect(@item.publisher.id).to eq(@pub.id)
            expect(@item.collection.id).to eq(@coll.id)
            expect(response).to render_template :edit
         end

         it "updates an item having a publisher and a collection by changing the publisher by a new one and changing the collection to one which does not belong to any publisher" do
            collection = FactoryGirl.create(:collection)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_id: @pub.id, collection_id: @coll.id, publisher_attributes: {"name"=>"Publisher2", "about"=>"", "id"=>@pub.id}, collection_attributes: {"name"=>collection.name, "about"=>collection.about, "id"=>@coll.id})
            @item.reload
             puts @item.inspect
            expect(@item.publisher.name).to eq("Publisher2")
            expect(@item.collection.id).to eq(collection.id)
             expect(@item.collection.publisher.name).to eq("Publisher2")
         end

         it "updates an item having a publisher and a collection by changing the publisher by a new one and changing the collection to a new one" do
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_id: @pub.id, collection_id: @coll.id, publisher_attributes: {"name"=>"Publisher3", "about"=>"", "id"=>@pub.id}, collection_attributes: {"name"=>"Collection2", "about"=>"", "id"=>@coll.id})
            @item.reload
            expect(@item.publisher.name).to eq("Publisher3")
            expect(@item.collection.name).to eq("Collection2")
            expect(@item.collection.publisher.name).to eq("Publisher3")
         end

         it "does not update an item having a publisher and a collection by changing the publisher by a new one and keeping the collection unchanged" do
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_id: @pub.id, collection_id: @coll.id, publisher_attributes: {"name"=>"Publisher4", "about"=>"", "id"=>@pub.id}, collection_attributes: {"name"=>@coll.name, "about"=>@coll.about, "id"=>@coll.id})
            @item.reload
            expect(@item.publisher.id).to eq(@pub.id)
            expect(@item.collection.id).to eq(@coll.id)
            expect(response).to render_template :edit
         end

         it "updates an item having a publisher and a collection by keeping the publisher unchanged and changing the collection to another one of the publisher" do
            collection = FactoryGirl.create(:collection, publisher_id: @pub.id)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_id: @pub.id, collection_id: @coll.id, publisher_attributes: {"name"=>@pub.name, "about"=>@pub.about, "id"=>@pub.id}, collection_attributes: {"name"=>collection.name, "about"=>collection.about, "id"=>@coll.id})
            @item.reload
            expect(@item.publisher.id).to eq(@pub.id)
            expect(@item.collection.id).to eq(collection.id)
            expect(@item.collection.publisher.id).to eq(@pub.id)
         end

         it "does not update an item having a publisher and a collection by keeping the publisher unchanged and changing the collection to one which does not belong to the publisher" do
            publisher = FactoryGirl.create(:publisher)
            collection = FactoryGirl.create(:collection, publisher_id: publisher.id)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_id: @pub.id, collection_id: @coll.id, publisher_attributes: {"name"=>@pub.name, "about"=>@pub.about, "id"=>@pub.id}, collection_attributes: {"name"=>collection.name, "about"=>collection.about, "id"=>@coll.id})
            @item.reload
            expect(@item.publisher.id).to eq(@pub.id)
            expect(@item.collection.id).to eq(@coll.id)
            expect(response).to render_template :edit
         end

         it "updates an item having a publisher and a collection by keeping the publisher unchanged and changing the collection to a new one" do
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_id: @pub.id, collection_id: @coll.id, publisher_attributes: {"name"=>@pub.name, "about"=>@pub.about, "id"=>@pub.id}, collection_attributes: {"name"=>"Collection3", "about"=>"", "id"=>@coll.id})
            @item.reload
            expect(@item.publisher.id).to eq(@pub.id)
            expect(@item.collection.name).to eq("Collection3")
            expect(@item.collection.publisher.id).to eq(@pub.id)
         end

         it "updates an item having a publisher and a collection by keeping the publisher unchanged and keeping the collection unchanged" do
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_id: @pub.id, collection_id: @coll.id, publisher_attributes: {"name"=>@pub.name, "about"=>@pub.about, "id"=>@pub.id}, collection_attributes: {"name"=>@coll.name, "about"=>@coll.about, "id"=>@coll.id})
            @item.reload
            expect(@item.publisher.id).to eq(@pub.id)
            expect(@item.collection.id).to eq(@coll.id)
            expect(@item.collection.publisher.id).to eq(@pub.id)
         end

         it "updates an item having a publisher and no collection by changing the publisher by an existing one and adding one of the publisher collections" do
            @coll.items.delete(@item)
            @item.reload
            expect(@item.collection).to be_nil
            publisher = FactoryGirl.create(:publisher)
            collection = FactoryGirl.create(:collection, publisher_id: publisher.id)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_id: @pub.id, publisher_attributes: {"name"=>publisher.name, "about"=>publisher.about, "id"=>@pub.id}, collection_attributes: {"name"=>collection.name, "about"=>collection.about})
            @item.reload
            expect(@item.publisher.id).to eq(publisher.id)
            expect(@item.collection.id).to eq(collection.id)
            expect(@item.collection.publisher.id).to eq(publisher.id)
         end

         it "does not update an item having a publisher and no collection by changing the publisher by an existing one and adding an existing collection which does not belong to the new publisher" do
            @coll.items.delete(@item)
            @item.reload
            expect(@item.collection).to be_nil
            publisher = FactoryGirl.create(:publisher)
            collpublisher = FactoryGirl.create(:publisher)
            collection = FactoryGirl.create(:collection, publisher_id: collpublisher.id)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_id: @pub.id, publisher_attributes: {"name"=>publisher.name, "about"=>publisher.about, "id"=>@pub.id}, collection_attributes: {"name"=>collection.name, "about"=>collection.about})
            @item.reload
            expect(@item.publisher.id).to eq(@pub.id)
            expect(@item.collection).to be_nil
            expect(response).to render_template :edit
         end

         it "updates an item having a publisher and no collection by changing the publisher by an existing one and changing the collection to a new one" do
            @coll.items.delete(@item)
            @item.reload
            expect(@item.collection).to be_nil
            publisher = FactoryGirl.create(:publisher)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_id: @pub.id, publisher_attributes: {"name"=>publisher.name, "about"=>publisher.about, "id"=>@pub.id}, collection_attributes: {"name"=>"Collection4", "about"=>""})
            @item.reload
            expect(@item.publisher.id).to eq(publisher.id)
            expect(@item.collection.name).to eq("Collection4")
            expect(@item.collection.publisher.id).to eq(publisher.id)
         end

         it "updates an item having a publisher and no collection by changing the publisher by an existing one and keeping the item without collection" do
            @coll.items.delete(@item)
            @item.reload
            expect(@item.collection).to be_nil
            publisher = FactoryGirl.create(:publisher)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_id: @pub.id, publisher_attributes: {"name"=>publisher.name, "about"=>publisher.about, "id"=>@pub.id}, collection_attributes: {"name"=>"", "about"=>""})
            @item.reload
            expect(@item.publisher.id).to eq(publisher.id)
            expect(@item.collection).to be_nil
         end

         it "does not update an item having a publisher and no collection by changing the publisher by a new one and adding a collection which belongs to an existing publisher" do
            @coll.items.delete(@item)
            @item.reload
            expect(@item.collection).to be_nil
            collpublisher = FactoryGirl.create(:publisher)
            collection = FactoryGirl.create(:collection, publisher_id: collpublisher.id)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_id: @pub.id, publisher_attributes: {"name"=>"Publisher5", "about"=>"", "id"=>@pub.id}, collection_attributes: {"name"=>collection.name, "about"=>collection.about})
            @item.reload
            expect(@item.publisher.id).to eq(@pub.id)
            expect(@item.collection).to be_nil
            expect(response).to render_template :edit
         end

         it "updates an item having a publisher and no collection by changing the publisher by a new one and adding a collection which does not belong to any publisher" do
            @coll.items.delete(@item)
            @item.reload
            expect(@item.collection).to be_nil
            collection = FactoryGirl.create(:collection)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_id: @pub.id, publisher_attributes: {"name"=>"Publisher6", "about"=>"", "id"=>@pub.id}, collection_attributes: {"name"=>collection.name, "about"=>collection.about})
            @item.reload
            expect(@item.publisher.name).to eq("Publisher6")
            expect(@item.collection.id).to eq(collection.id)
            expect(@item.collection.publisher.name).to eq("Publisher6")
         end

         it "updates an item having a publisher and no collection by changing the publisher by a new one and adding a new collection" do
            @coll.items.delete(@item)
            @item.reload
            expect(@item.collection).to be_nil
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_id: @pub.id, publisher_attributes: {"name"=>"Publisher7", "about"=>"", "id"=>@pub.id}, collection_attributes: {"name"=>"Collection5", "about"=>""})
            @item.reload
            expect(@item.publisher.name).to eq("Publisher7")
            expect(@item.collection.name).to eq("Collection5")
            expect(@item.collection.publisher.name).to eq("Publisher7")
         end

         it "updates an item having a publisher and no collection by changing the publisher by a new one and keeping the item without collection" do
            @coll.items.delete(@item)
            @item.reload
            expect(@item.collection).to be_nil
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_id: @pub.id, publisher_attributes: {"name"=>"Publisher8", "about"=>"", "id"=>@pub.id}, collection_attributes: {"name"=>"", "about"=>""})
            @item.reload
             expect(@item.publisher.name).to eq("Publisher8")
             expect(@item.collection).to be_nil
             expect(@item.publisher.collections).to be_empty
         end

         it "** updates an item having a publisher and no collection by keeping the publisher unchanged and adding one of the publisher collections" do
            @coll.items.delete(@item)
            @item.reload
            expect(@item.collection).to be_nil
            collection = FactoryGirl.create(:collection, publisher_id: @pub.id)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_id: @pub.id, publisher_attributes: {"name"=>@pub.name, "about"=>@pub.about, "id"=>@pub.id}, collection_attributes: {"name"=>collection.name, "about"=>collection.about})
            @item.reload
            expect(@item.publisher.id).to eq(@pub.id)
            expect(@item.collection.id).to eq(collection.id)
            expect(@item.collection.publisher.id).to eq(@pub.id)
         end

         it "does not update an item having a publisher and no collection by keeping the publisher unchanged and adding a collection which does not belong to the publisher" do
            @coll.items.delete(@item)
            @item.reload
            expect(@item.collection).to be_nil
            publisher = FactoryGirl.create(:publisher)
            collection = FactoryGirl.create(:collection, publisher_id: publisher.id)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_id: @pub.id, publisher_attributes: {"name"=>@pub.name, "about"=>@pub.about, "id"=>@pub.id}, collection_attributes: {"name"=>collection.name, "about"=>collection.about})
            @item.reload
            expect(@item.publisher.id).to eq(@pub.id)
            expect(@item.collection).to be_nil
            expect(response).to render_template :edit
         end

         it "** updates an item having a publisher and no collection by keeping the publisher unchanged and adding a new collection" do
            @coll.items.delete(@item)
            @item.reload
            expect(@item.collection).to be_nil
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_id: @pub.id, publisher_attributes: {"name"=>@pub.name, "about"=>@pub.about, "id"=>@pub.id}, collection_attributes: {"name"=>"Collection6", "about"=>""})
            @item.reload
            expect(@item.publisher.id).to eq(@pub.id)
            expect(@item.collection.name).to eq("Collection6")
            expect(@item.collection.publisher.id).to eq(@pub.id)
         end

         it "updates an item having a publisher and no collection by keeping the publisher unchanged and keeping the item without collection" do
            @coll.items.delete(@item)
            @item.reload
            expect(@item.collection).to be_nil
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_id: @pub.id, publisher_attributes: {"name"=>@pub.name, "about"=>@pub.about, "id"=>@pub.id}, collection_attributes: {"name"=>"", "about"=>""})
            @item.reload
            expect(@item.publisher.id).to eq(@pub.id)
            expect(@item.collection).to be_nil
         end

         it "updates an item having no publisher and a collection by adding an existing publisher and changing the collection to one of the new publisher" do
            @pub.items.delete(@item)
            @item.reload
            expect(@item.publisher).to be_nil
            publisher = FactoryGirl.create(:publisher)
            collection = FactoryGirl.create(:collection, publisher_id: publisher.id)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, collection_id: @coll.id, publisher_attributes: {"name"=>publisher.name, "about"=>publisher.about}, collection_attributes: {"name"=>collection.name, "about"=>collection.about, "id"=>@coll.id})
            @item.reload
            expect(@item.publisher.id).to eq(publisher.id)
            expect(@item.collection.id).to eq(collection.id)
            expect(@item.collection.publisher.id).to eq(publisher.id)
         end

         it "does not update an item having no publisher and a collection by adding an existing publisher and changing the collection to one which does not belong to the new publisher" do
            @pub.items.delete(@item)
            @item.reload
            expect(@item.publisher).to be_nil
            publisher = FactoryGirl.create(:publisher)
            collpublisher = FactoryGirl.create(:publisher)
            collection = FactoryGirl.create(:collection, publisher_id: collpublisher.id)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, collection_id: @coll.id, publisher_attributes: {"name"=>publisher.name, "about"=>publisher.about}, collection_attributes: {"name"=>collection.name, "about"=>collection.about, "id"=>@coll.id})
            @item.reload
            expect(@item.collection.id).to eq(@coll.id)
            expect(@item.publisher).to be_nil
            expect(response).to render_template :edit
         end

         it "** updates an item having no publisher and a collection by adding an existing publisher and changing the collection to a new one" do
            @pub.items.delete(@item)
            @item.reload
            expect(@item.publisher).to be_nil
            publisher = FactoryGirl.create(:publisher)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, collection_id: @coll.id, publisher_attributes: {"name"=>publisher.name, "about"=>publisher.about}, collection_attributes: {"name"=>"Collection7", "about"=>"", "id"=>@coll.id})
            @item.reload
            expect(@item.publisher.id).to eq(publisher.id)
            expect(@item.collection.name).to eq("Collection7")
            expect(@item.collection.publisher.id).to eq(publisher.id)
         end

         it "does not update an item having no publisher and a collection by adding an existing publisher different from the collection publisher and keeping the collection unchanged" do
            @pub.items.delete(@item)
            @item.reload
            expect(@item.publisher).to be_nil
            publisher = FactoryGirl.create(:publisher)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, collection_id: @coll.id, publisher_attributes: {"name"=>publisher.name, "about"=>publisher.about}, collection_attributes: {"name"=>@coll.name, "about"=>@coll.about, "id"=>@coll.id})
            @item.reload
            expect(@item.collection.id).to eq(@coll.id)
            expect(@item.publisher).to be_nil
            expect(response).to render_template :edit
         end

         it "updates an item having no publisher and a collection by adding the collection publisher and keeping the collection unchanged" do
            @pub.items.delete(@item)
            @item.reload
            expect(@item.publisher).to be_nil
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, collection_id: @coll.id, publisher_attributes: {"name"=>@coll.publisher.name, "about"=>@coll.publisher.about}, collection_attributes: {"name"=>@coll.name, "about"=>@coll.about, "id"=>@coll.id})
            @item.reload
            expect(@item.publisher.id).to eq(@coll.publisher.id)
            expect(@item.collection.id).to eq(@coll.id)
            expect(@item.collection.publisher.id).to eq(@coll.publisher.id)
         end

         it "does not update an item having no publisher and a collection by adding a new publisher and changing the collection to one which belongs to an existing publisher" do
            @pub.items.delete(@item)
            @item.reload
            expect(@item.publisher).to be_nil
            publisher = FactoryGirl.create(:publisher)
            collection = FactoryGirl.create(:collection, publisher_id: publisher.id)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, collection_id: @coll.id, publisher_attributes: {"name"=>"Great Publisher11", "about"=>""}, collection_attributes: {"name"=>collection.name, "about"=>collection.about, "id"=>@coll.id})
            @item.reload
            expect(@item.publisher).to be_nil
            expect(@item.collection.id).to eq(@coll.id)
            expect(response).to render_template :edit
         end

         it "** updates an item having no publisher and a collection by adding a new publisher and changing the collection to one which does not belong to any publisher" do
            @pub.items.delete(@item)
            @item.reload
            expect(@item.publisher).to be_nil
            collection = FactoryGirl.create(:collection)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, collection_id: @coll.id, publisher_attributes: {"name"=>"Publisher9", "about"=>""}, collection_attributes: {"name"=>collection.name, "about"=>collection.about, "id"=>@coll.id})
            @item.reload
            expect(@item.publisher.name).to eq("Publisher9")
            expect(@item.collection.id).to eq(collection.id)
            expect(@item.collection.publisher.name).to eq("Publisher9")
         end

         it "** updates an item having no publisher and a collection by adding a new publisher and changing the collection to a new one"  do
            @pub.items.delete(@item)
            @item.reload
            expect(@item.publisher).to be_nil
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, collection_id: @coll.id, publisher_attributes: {"name"=>"Publisher10", "about"=>""}, collection_attributes: {"name"=>"Collection8", "about"=>"", "id"=>@coll.id})
            @item.reload
            expect(@item.publisher.name).to eq("Publisher10")
            expect(@item.collection.name).to eq("Collection8")
            expect(@item.collection.publisher.name).to eq("Publisher10")
         end

         it "does not update an item having no publisher and a collection by adding a new publisher and keeping the collection unchanged"  do
            @pub.items.delete(@item)
            @item.reload
            expect(@item.publisher).to be_nil
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, collection_id: @coll.id, publisher_attributes: {"name"=>"Publisher12", "about"=>""}, collection_attributes: {"name"=>@coll.name, "about"=>@coll.about, "id"=>@coll.id})
            @item.reload
            expect(@item.publisher).to be_nil
            expect(@item.collection.id).to eq(@coll.id)
            expect(response).to render_template :edit
         end

         it "** updates an item having no publisher and a collection by keeping no publisher and changing the collection to another existing one" do
            @pub.items.delete(@item)
            @item.reload
            expect(@item.publisher).to be_nil
            publisher = FactoryGirl.create(:publisher)
            collection = FactoryGirl.create(:collection, publisher_id: publisher.id)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, collection_id: @coll.id, publisher_attributes: {"name"=>"", "about"=>""}, collection_attributes: {"name"=>collection.name, "about"=>collection.about, "id"=>@coll.id})
            @item.reload
            expect(@item.publisher.id).to eq(collection.publisher.id)
            expect(@item.collection.id).to eq(collection.id)
         end

         it "does not update an item having no publisher and a collection by keeping no publisher and changing the collection to one which does not belong to any publisher" do
            @pub.items.delete(@item)
            @item.reload
            expect(@item.publisher).to be_nil
            collection = FactoryGirl.create(:collection)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, collection_id: @coll.id, publisher_attributes: {"name"=>"", "about"=>""}, collection_attributes: {"name"=>collection.name, "about"=>collection.about, "id"=>@coll.id})
            @item.reload
            expect(@item.publisher).to be_nil
            expect(@item.collection.id).to eq(@coll.id)
            expect(response).to render_template :edit
         end

         it "** does not update an item having no publisher and a collection by keeping no publisher and changing the collection to a new one" do
            @pub.items.delete(@item)
            @item.reload
            expect(@item.publisher).to be_nil
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, collection_id: @coll.id, publisher_attributes: {"name"=>"", "about"=>""}, collection_attributes: {"name"=>"Collection9", "about"=>"", "id"=>@coll.id})
            @item.reload
            expect(@item.publisher).to be_nil
            expect(@item.collection.id).to eq(@coll.id)
            expect(response).to render_template :edit
         end

         it "** updates an item having no publisher and a collection by keeping no publisher and keeping the collection unchanged" do
            @pub.items.delete(@item)
            @item.reload
            expect(@item.publisher).to be_nil
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, collection_id: @coll.id, publisher_attributes: {"name"=>"", "about"=>""}, collection_attributes: {"name"=>@coll.name, "about"=>@coll.about, "id"=>@coll.id})
            @item.reload
            expect(@item.publisher.id).to eq(@pub.id)
            expect(@item.collection.id).to eq(@coll.id)
         end

         it "updates an item having no publisher and no collection by adding an existing publisher and adding one of the publisher collections" do
            @coll.items.delete(@item)
            @pub.items.delete(@item)
            @item.reload
            expect(@item.publisher).to be_nil
            expect(@item.collection).to be_nil
            publisher = FactoryGirl.create(:publisher)
            collection = FactoryGirl.create(:collection, publisher_id: publisher.id)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_attributes: {"name"=>publisher.name, "about"=>publisher.about}, collection_attributes: {"name"=>collection.name, "about"=>collection.about})
            @item.reload
            expect(@item.publisher.id).to eq(publisher.id)
            expect(@item.collection.id).to eq(collection.id)
         end

         it "does not update an item having no publisher and no collection by adding an existing publisher and adding a collection which does not belong to the publisher" do
            @coll.items.delete(@item)
            @pub.items.delete(@item)
            @item.reload
            expect(@item.publisher).to be_nil
            expect(@item.collection).to be_nil
            publisher = FactoryGirl.create(:publisher)
            otherpublisher = FactoryGirl.create(:publisher)
            collection = FactoryGirl.create(:collection, publisher_id: otherpublisher.id)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_attributes: {"name"=>publisher.name, "about"=>publisher.about}, collection_attributes: {"name"=>collection.name, "about"=>collection.about})
            @item.reload
            expect(@item.publisher).to be_nil
            expect(@item.collection).to be_nil
            expect(response).to render_template :edit
         end

         it "updates an item having no publisher and no collection by adding an existing publisher and adding a new collection" do
            @coll.items.delete(@item)
            @pub.items.delete(@item)
            @item.reload
            expect(@item.publisher).to be_nil
            expect(@item.collection).to be_nil
            publisher = FactoryGirl.create(:publisher)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_attributes: {"name"=>publisher.name, "about"=>publisher.about}, collection_attributes: {"name"=>"Collection10", "about"=>""})
            @item.reload
            expect(@item.publisher.id).to eq(publisher.id)
            expect(@item.collection.name).to eq("Collection10")
            expect(@item.collection.publisher.id).to eq(publisher.id)
         end

         it "updates an item having no publisher and no collection by adding an existing publisher and keeping the item without collection" do
            @coll.items.delete(@item)
            @pub.items.delete(@item)
            @item.reload
            expect(@item.publisher).to be_nil
            expect(@item.collection).to be_nil
            publisher = FactoryGirl.create(:publisher)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_attributes: {"name"=>publisher.name, "about"=>publisher.about}, collection_attributes: {"name"=>"", "about"=>""})
            @item.reload
            expect(@item.publisher.id).to eq(publisher.id)
            expect(@item.collection).to be_nil
         end

         it "does not update an item having no publisher and no collection by adding a new publisher and adding a collection which belongs to an existing publisher" do
            @coll.items.delete(@item)
            @pub.items.delete(@item)
            @item.reload
            expect(@item.publisher).to be_nil
            expect(@item.collection).to be_nil
            publisher = FactoryGirl.create(:publisher)
            collection = FactoryGirl.create(:collection, publisher_id: publisher.id)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_attributes: {"name"=>"Publisher13", "about"=>""}, collection_attributes: {"name"=>collection.name, "about"=>collection.about})
            @item.reload
            expect(@item.publisher).to be_nil
            expect(@item.collection).to be_nil
            expect(response).to render_template :edit
         end

         it "** updates an item having no publisher and no collection by adding a new publisher and adding a collection which does not belong to any publisher" do
            @coll.items.delete(@item)
            @pub.items.delete(@item)
            @item.reload
            expect(@item.publisher).to be_nil
            expect(@item.collection).to be_nil
            collection = FactoryGirl.create(:collection)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_attributes: {"name"=>"Wonderful Publisher", "about"=>""}, collection_attributes: {"name"=>collection.name, "about"=>collection.about})
            @item.reload
            expect(@item.publisher.name).to eq("Wonderful Publisher")
            expect(@item.collection.id).to eq(collection.id)
            expect(@item.collection.publisher.name).to eq("Wonderful Publisher")
         end

         it "** updates an item having no publisher and no collection by adding a new publisher and adding a new collection" do
            @coll.items.delete(@item)
            @pub.items.delete(@item)
            @item.reload
            expect(@item.publisher).to be_nil
            expect(@item.collection).to be_nil
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_attributes: {"name"=>"Publisher14", "about"=>""}, collection_attributes: {"name"=>"Collection11", "about"=>""})
            @item.reload
            expect(@item.publisher.name).to eq("Publisher14")
            expect(@item.collection.name).to eq("Collection11")
            expect(@item.collection.publisher.name).to eq("Publisher14")
         end

         it "updates an item having no publisher and no collection by adding a new publisher and keeping the item without collection" do
            @coll.items.delete(@item)
            @pub.items.delete(@item)
            @item.reload
            expect(@item.publisher).to be_nil
            expect(@item.collection).to be_nil
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_attributes: {"name"=>"Publisher15", "about"=>""}, collection_attributes: {"name"=>"", "about"=>""})
            @item.reload
            expect(@item.publisher.name).to eq("Publisher15")
            expect(@item.collection).to be_nil
         end

         it "updates an item having no publisher and no collection by keeping the item without publisher and adding a collection linked to an existing publisher" do
            @coll.items.delete(@item)
            @pub.items.delete(@item)
            @item.reload
            expect(@item.publisher).to be_nil
            expect(@item.collection).to be_nil
            publisher = FactoryGirl.create(:publisher)
            collection = FactoryGirl.create(:collection, publisher_id: publisher.id)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_attributes: {"name"=>"", "about"=>""}, collection_attributes: {"name"=>collection.name, "about"=>collection.about})
            @item.reload
             expect(@item.publisher.id).to eq(publisher.id)
             expect(@item.collection.id).to eq(collection.id)
             expect(@item.collection.publisher.id).to eq(publisher.id)
         end

         it "does not update an item having no publisher and no collection by keeping the item without publisher and adding a collection which does not belong to any publisher" do
            @coll.items.delete(@item)
            @pub.items.delete(@item)
            @item.reload
            expect(@item.publisher).to be_nil
            expect(@item.collection).to be_nil
            collection = FactoryGirl.create(:collection)
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_attributes: {"name"=>"", "about"=>""}, collection_attributes: {"name"=>collection.name, "about"=>collection.about})
            @item.reload
            expect(@item.publisher).to be_nil
            expect(@item.collection).to be_nil
            expect(response).to render_template :edit
         end

         it "** does not update an item having no publisher and no collection by keeping the item without publisher and adding a new collection" do
            @coll.items.delete(@item)
            @pub.items.delete(@item)
            @item.reload
            expect(@item.publisher).to be_nil
            expect(@item.collection).to be_nil
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_attributes: {"name"=>"", "about"=>""}, collection_attributes: {"name"=>"Collection12", "about"=>""})
            @item.reload
            expect(@item.publisher).to be_nil
            expect(@item.collection).to be_nil
            expect(response).to render_template :edit
         end

         it "updates an item having no publisher and no collection by keeping the item without publisher and without collection" do
            @coll.items.delete(@item)
            @pub.items.delete(@item)
            @item.reload
            expect(@item.publisher).to be_nil
            expect(@item.collection).to be_nil
            @controller.stub(:current_ability).and_return(@ability)
            @ability.can :update, @item
            put :update, id: @item, item: FactoryGirl.attributes_for(:item, publisher_attributes: {"name"=>"", "about"=>""}, collection_attributes: {"name"=>"", "about"=>""})
            @item.reload
            expect(@item.publisher).to be_nil
            expect(@item.collection).to be_nil
         end

      end

   end

   describe 'DELETE destroy' do
      before :each do
         @item = FactoryGirl.create(:item)
      end

      it "deletes the item" do
         @controller.stub(:current_ability).and_return(@ability)
         @ability.can :destroy, @item
         expect{
            delete :destroy, id: @item
         }.to change(Item,:count).by(-1)
      end

      it "redirects to items#index" do
         @controller.stub(:current_ability).and_return(@ability)
         @ability.can :destroy, @item
         delete :destroy, id: @item
         expect(response).to redirect_to items_url
      end
   end

end
