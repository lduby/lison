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
    it "populates an array of authors" do
      author = FactoryGirl.create(:author)
      get :new
      expect(assigns(:authors)).to eq([author])
    end
    it "populates an array of illustrators" do
      illustrator = FactoryGirl.create(:illustrator)
      get :new
      expect(assigns(:illustrators)).to eq([illustrator])
    end
    it "populates an array of publishers" do
      publisher = FactoryGirl.create(:publisher)
      get :new
      expect(assigns(:publishers)).to eq([publisher])
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
      it "associates authors to the item" do
        author = FactoryGirl.create(:author)
        post :create, item: FactoryGirl.attributes_for(:item, author_ids: [author.id])
        expect(assigns(:item).authors).to eq([author])
      end
      it "associates illustrators to the item" do
        illustrator = FactoryGirl.create(:illustrator)
        post :create, item: FactoryGirl.attributes_for(:item, illustrator_ids: [illustrator.id])
        expect(assigns(:item).illustrators).to eq([illustrator])
      end
      it "associates a publisher to the item" do
        publisher = FactoryGirl.create(:publisher)
        post :create, item: FactoryGirl.attributes_for(:item, publisher_id: publisher.id)
        expect(assigns(:item).publisher).to eq(publisher)
        expect(publisher.items).to include(assigns(:item))
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

  describe 'PUT #update' do
    before :each do
      @item = FactoryGirl.create(:item, title: "Test Item")
    end

    context "with valid attributes" do
      it "locates the requested @item" do
        put :update, id: @item, item: FactoryGirl.attributes_for(:item)
        expect(assigns(:item)).to eq(@item)
      end

      it "changes @item's attributes" do
        put :update, id: @item,
          item: FactoryGirl.attributes_for(:item, title: "Updated test item")
        @item.reload
        expect(@item.title).to eq("Updated test item")
      end

      it "redirects to the updated item" do
        put :update, id: @item, item: FactoryGirl.attributes_for(:item)
        expect(response).to redirect_to @item
      end
    end

    context "with invalid attributes" do
      it "locates the requested @item" do
        put :update, id: @item, item: FactoryGirl.attributes_for(:invalid_item)
        expect(assigns(:item)).to eq(@item)
      end

      it "does not change @item's attributes" do
        put :update, id: @item,
          item: FactoryGirl.attributes_for(:item, title: nil)
        @item.reload
        expect(@item.title).to eq("Test Item")
      end

      it "re-renders the edit method" do
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
      expect{
        delete :destroy, id: @item
      }.to change(Item,:count).by(-1)
    end

    it "redirects to items#index" do
      delete :destroy, id: @item
      expect(response).to redirect_to items_url
    end
  end

end
