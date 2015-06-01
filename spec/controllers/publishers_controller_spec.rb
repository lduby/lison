require 'rails_helper'

RSpec.describe PublishersController, type: :controller do

  describe "GET #index" do
    it "populates an array of publishers" do
      publisher = FactoryGirl.create(:publisher)
      get :index
      expect(assigns(:publishers)).to eq([publisher])
    end
    it "renders the publishers :index view" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    it "assigns the requested publisher to @publisher" do
      publisher = FactoryGirl.create(:publisher)
      get :show, id: publisher
      expect(assigns(:publisher)).to eq(publisher)
    end
    it "renders the publisher :show template" do
      get :show, id: FactoryGirl.create(:publisher)
      expect(response).to render_template :show
    end
    it 'gets the publisher items' do
      publisher = FactoryGirl.create(:publisher)
      item1 = FactoryGirl.create(:item, publisher_id: publisher.id )
      item2 = FactoryGirl.create(:item, publisher_id: publisher.id )
      get :show, id: publisher
      expect(assigns(:publisher).items).to include(item1)
      expect(assigns(:publisher).items).to include(item2)
    end
  end

  describe "GET #new" do
    it "assigns a new Publisher to @publisher" do
      get :new
      expect(assigns(:publisher)).to be_a_new(Publisher)
      # expect(assigns(:business).addresses.first).to be_a_new(Address)
    end
    it "renders the publisher :new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new publisher in the database" do
        expect{
          post :create, publisher: FactoryGirl.attributes_for(:publisher)
        }.to change(Publisher,:count).by(1)
      end
      it "redirects to the publishers :index page" do
        post :create, publisher: FactoryGirl.attributes_for(:publisher)
        expect(response).to redirect_to Publisher.last
      end
    end

    context "with invalid attributes" do
      it "does not save the new publisher in the database" do
        expect{
          post :create, publisher: FactoryGirl.attributes_for(:invalid_publisher)
        }.to_not change(Publisher,:count)
      end
      it "re-renders the publisher :new template" do
        post :create, publisher: FactoryGirl.attributes_for(:invalid_publisher)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PUT #update' do
    before :each do
      @publisher = FactoryGirl.create(:publisher, name: "Days of Wonder")
    end

    context "with valid attributes" do
      it "locates the requested @publisher" do
        put :update, id: @publisher, publisher: FactoryGirl.attributes_for(:publisher)
        expect(assigns(:publisher)).to eq(@publisher)
      end

      it "changes @publisher's attributes" do
        put :update, id: @publisher,
          publisher: FactoryGirl.attributes_for(:publisher, name: "Iello")
        @publisher.reload
        expect(@publisher.name).to eq("Iello")
      end

      it "redirects to the updated publisher" do
        put :update, id: @publisher, publisher: FactoryGirl.attributes_for(:publisher)
        expect(response).to redirect_to @publisher
      end
    end

    context "with invalid attributes" do
      it "locates the requested @publisher" do
        put :update, id: @publisher, publisher: FactoryGirl.attributes_for(:invalid_publisher)
        expect(assigns(:publisher)).to eq(@publisher)
      end

      it "does not change @publisher's attributes" do
        put :update, id: @publisher,
          publisher: FactoryGirl.attributes_for(:publisher, name: nil)
        @publisher.reload
        expect(@publisher.name).to eq("Days of Wonder")
      end

      it "re-renders the edit method" do
        put :update, id: @publisher, publisher: FactoryGirl.attributes_for(:invalid_publisher)
        expect(response).to render_template :edit
      end
    end

  end

  describe 'DELETE destroy' do
    before :each do
      @publisher = FactoryGirl.create(:publisher)
    end

    it "deletes the publisher" do
      expect{
        delete :destroy, id: @publisher
      }.to change(Publisher,:count).by(-1)
    end

    it "redirects to publishers#index" do
      delete :destroy, id: @publisher
      expect(response).to redirect_to publishers_url
    end
  end

end
