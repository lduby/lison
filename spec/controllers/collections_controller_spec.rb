require 'rails_helper'

RSpec.describe CollectionsController, type: :controller do

  describe "GET #index" do
    it "populates an array of collections" do
      collection = FactoryGirl.create(:collection)
      get :index
      expect(assigns(:collections)).to eq([collection])
    end
    it "renders the collections :index view" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    it "assigns the requested collection to @collection" do
      collection = FactoryGirl.create(:collection)
      get :show, id: collection
      expect(assigns(:collection)).to eq(collection)
    end
    it "renders the collection :show template" do
      get :show, id: FactoryGirl.create(:collection)
      expect(response).to render_template :show
    end
    it 'gets the collection items'
  end

  describe "GET #new" do
    it "assigns a new Collection to @collection" do
      get :new
      expect(assigns(:collection)).to be_a_new(Collection)
      # expect(assigns(:business).addresses.first).to be_a_new(Address)
    end
    it "renders the collection :new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new collection in the database" do
        expect{
          post :create, collection: FactoryGirl.attributes_for(:collection)
        }.to change(Collection,:count).by(1)
      end
      it "redirects to the collections :index page" do
        post :create, collection: FactoryGirl.attributes_for(:collection)
        expect(response).to redirect_to Collection.last
      end
    end

    context "with invalid attributes" do
      it "does not save the new collection in the database" do
        expect{
          post :create, collection: FactoryGirl.attributes_for(:invalid_collection)
        }.to_not change(Collection,:count)
      end
      it "re-renders the collection :new template" do
        post :create, collection: FactoryGirl.attributes_for(:invalid_collection)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PUT #update' do
    before :each do
      @collection = FactoryGirl.create(:collection, name: "Days of Wonder")
    end

    context "with valid attributes" do
      it "locates the requested @collection" do
        put :update, id: @collection, collection: FactoryGirl.attributes_for(:collection)
        expect(assigns(:collection)).to eq(@collection)
      end

      it "changes @collection's attributes" do
        put :update, id: @collection,
          collection: FactoryGirl.attributes_for(:collection, name: "Iello")
        @collection.reload
        expect(@collection.name).to eq("Iello")
      end

      it "redirects to the updated collection" do
        put :update, id: @collection, collection: FactoryGirl.attributes_for(:collection)
        expect(response).to redirect_to @collection
      end
    end

    context "with invalid attributes" do
      it "locates the requested @collection" do
        put :update, id: @collection, collection: FactoryGirl.attributes_for(:invalid_collection)
        expect(assigns(:collection)).to eq(@collection)
      end

      it "does not change @collection's attributes" do
        put :update, id: @collection,
          collection: FactoryGirl.attributes_for(:collection, name: nil)
        @collection.reload
        expect(@collection.name).to eq("Days of Wonder")
      end

      it "re-renders the edit method" do
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
      expect{
        delete :destroy, id: @collection
      }.to change(Collection,:count).by(-1)
    end

    it "redirects to collections#index" do
      delete :destroy, id: @collection
      expect(response).to redirect_to collections_url
    end
  end

end