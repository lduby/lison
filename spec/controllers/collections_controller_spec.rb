require 'rails_helper'

RSpec.describe CollectionsController, type: :controller do

  before :each do
    @role = FactoryGirl.create(:role, name: 'Team')
    @user = FactoryGirl.create(:user, :donald)
    sign_in @user

    @ability = Object.new
    @ability.extend(CanCan::Ability)

  end

  describe "GET #index" do
    it "populates an array of collections" do
      # @ability.can :index, Collection
      collection = FactoryGirl.create(:collection)
      get :index
      expect(assigns(:collections)).to eq([collection])
    end
    it "renders the collections :index view" do
      # @ability.can :index, Collection
      get :index
      # expect(response).to render_template :index
      assert_template :index
    end
  end

  describe "GET #show" do
    it "assigns the requested collection to @collection" do
      collection = FactoryGirl.create(:collection)

      @controller.stub(:current_ability).and_return(@ability)
      @ability.can :read, collection

      get :show, id: collection
      expect(assigns(:collection)).to eq(collection)
    end
    it "renders the collection :show template" do
      @controller.stub(:current_ability).and_return(@ability)
      @ability.can :read, Collection
      get :show, id: FactoryGirl.create(:collection)
      expect(response).to render_template :show
    end
    it 'gets the collection items' do
      collection = FactoryGirl.create(:collection)
      item1 = FactoryGirl.create(:item, collection_id: collection.id )
      item2 = FactoryGirl.create(:item, collection_id: collection.id )

      @controller.stub(:current_ability).and_return(@ability)
      @ability.can :read, collection

      get :show, id: collection
      expect(assigns(:collection).items).to include(item1)
      expect(assigns(:collection).items).to include(item2)
    end
  end

  describe "GET #new" do
    it "assigns a new Collection to @collection" do
      @controller.stub(:current_ability).and_return(@ability)
      @ability.can :create, Collection
      get :new
      expect(assigns(:collection)).to be_a_new(Collection)
      # expect(assigns(:business).addresses.first).to be_a_new(Address)
    end
    it "populates an array of publishers" do
      @controller.stub(:current_ability).and_return(@ability)
      @ability.can :create, Collection
      publisher = FactoryGirl.create(:publisher)
      get :new
      expect(assigns(:publishers)).to eq([publisher])
    end
    it "renders the collection :new template" do
      @controller.stub(:current_ability).and_return(@ability)
      @ability.can :create, Collection
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new collection in the database" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :create, Collection
        expect{
          post :create, collection: FactoryGirl.attributes_for(:collection)
        }.to change(Collection,:count).by(1)
      end
      it "redirects to the collections :index page" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :create, Collection
        post :create, collection: FactoryGirl.attributes_for(:collection)
        expect(response).to redirect_to Collection.last
      end
      it "associates a publisher to the collection" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :create, Collection
        publisher = FactoryGirl.create(:publisher)
        post :create, collection: FactoryGirl.attributes_for(:collection, publisher_id: publisher.id)
        expect(assigns(:collection).publisher).to eq(publisher)
        expect(publisher.collections).to include(assigns(:collection))
      end
    end

    context "with invalid attributes" do
      it "does not save the new collection in the database" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :create, Collection
        expect{
          post :create, collection: FactoryGirl.attributes_for(:invalid_collection)
        }.to_not change(Collection,:count)
      end
      it "re-renders the collection :new template" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :create, Collection
        post :create, collection: FactoryGirl.attributes_for(:invalid_collection)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PUT #update' do
    before :each do
      @publisher = FactoryGirl.create(:publisher)
      @collection = FactoryGirl.create(:collection, name: "Days of Wonder", :publisher => @publisher)
    end

    context "with valid attributes" do
      it "locates the requested @collection" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :update, Collection
        put :update, id: @collection, collection: FactoryGirl.attributes_for(:collection)
        expect(assigns(:collection)).to eq(@collection)
      end

      it "changes collection's attributes" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :update, Collection
        put :update, id: @collection,
          collection: FactoryGirl.attributes_for(:collection, name: "Iello")
        @collection.reload
        expect(@collection.name).to eq("Iello")
      end

      it "changes the associated publisher" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :update, Collection
        publisher2 = FactoryGirl.create(:publisher)
        put :update, id: @collection, collection: FactoryGirl.attributes_for(:collection, publisher_id: publisher2.id)
        @collection.reload
        expect(@collection.publisher).to eq(publisher2)
      end

      it "redirects to the updated collection" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :update, Collection
        put :update, id: @collection, collection: FactoryGirl.attributes_for(:collection)
        expect(response).to redirect_to @collection
      end
    end

    context "with invalid attributes" do
      it "locates the requested @collection" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :update, Collection
        put :update, id: @collection, collection: FactoryGirl.attributes_for(:invalid_collection)
        expect(assigns(:collection)).to eq(@collection)
      end

      it "does not change @collection's attributes" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :update, Collection
        put :update, id: @collection,
          collection: FactoryGirl.attributes_for(:collection, name: nil)
        @collection.reload
        expect(@collection.name).to eq("Days of Wonder")
      end

      it "re-renders the edit method" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :update, Collection
        put :update, id: @collection, collection: FactoryGirl.attributes_for(:invalid_collection)
        expect(response).to render_template :edit
      end
    end

  end

  describe 'DELETE destroy' do
    before :each do
      @collection = FactoryGirl.create(:collection)
    end

    it "deletes the collection" do
      @controller.stub(:current_ability).and_return(@ability)
      @ability.can :destroy, Collection
      expect{
        delete :destroy, id: @collection
      }.to change(Collection,:count).by(-1)
    end

    it "redirects to collections#index" do
      @controller.stub(:current_ability).and_return(@ability)
      @ability.can :destroy, Collection
      delete :destroy, id: @collection
      expect(response).to redirect_to collections_url
    end
  end

end
