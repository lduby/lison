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
   end

   describe 'PUT #update' do
      before :each do
         @auth = FactoryGirl.create(:author)
         @illust = FactoryGirl.create(:illustrator)
         @pub = FactoryGirl.create(:publisher)
         @coll = FactoryGirl.create(:collection, publisher_id: @pub.id)
         @th = FactoryGirl.create(:theme)
         @cat = FactoryGirl.create(:category)
         @item = FactoryGirl.create(:item, title: "Test Item", author_ids: [@auth.id], illustrator_ids: [@illust.id], publisher_id: @pub.id, collection_id: @coll.id, theme_ids: [@th.id], category_ids: [@cat.id])
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
            put :update, id: @item,
            item: FactoryGirl.attributes_for(:item, title: nil)
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
