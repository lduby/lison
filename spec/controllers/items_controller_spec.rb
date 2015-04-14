require 'rails_helper'

describe ItemsController do

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

  describe "GET #show" do
    it "assigns the requested item to @item" do
      item = FactoryGirl.create(:item)
      get :show, id: item
      expect(assigns(:item)).to eq(item)
    end
    it "renders the item :show template" do
      get :show, id: FactoryGirl.create(:item)
      expect(response).to render_template :show
    end
  end

  describe "GET #new" do
    it "assigns a new Item to @item" do
      get :new
      expect(assigns(:item)).to be_a_new(Item)
      # expect(assigns(:business).addresses.first).to be_a_new(Address)
    end
    it "renders the item :new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new item in the database" do
        expect{
          post :create, item: FactoryGirl.attributes_for(:item)
        }.to change(Item,:count).by(1)
      end
      it "redirects to the items :index page" do
        post :create, item: FactoryGirl.attributes_for(:item)
        expect(response).to redirect_to Item.last
      end
    end

    context "with invalid attributes" do
      it "does not save the new item in the database" do
        expect{
          post :create, item: FactoryGirl.attributes_for(:invalid_item)
        }.to_not change(Item,:count)
      end
      it "re-renders the item :new template" do
        post :create, item: FactoryGirl.attributes_for(:invalid_item)
        expect(response).to render_template :new
      end
    end
  end

end
