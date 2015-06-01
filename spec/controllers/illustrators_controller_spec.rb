require 'rails_helper'

RSpec.describe IllustratorsController, type: :controller do

  describe "GET #index" do
    it "populates an array of illustrators" do
      illustrator = FactoryGirl.create(:illustrator)
      get :index
      expect(assigns(:illustrators)).to eq([illustrator])
    end
    it "renders the illustrators :index view" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    it "assigns the requested illustrator to @illustrator" do
      illustrator = FactoryGirl.create(:illustrator)
      get :show, id: illustrator
      expect(assigns(:illustrator)).to eq(illustrator)
    end
    it "renders the illustrator :show template" do
      get :show, id: FactoryGirl.create(:illustrator)
      expect(response).to render_template :show
    end
    it 'gets the illustrator items' do
      illustrator = FactoryGirl.create(:illustrator)
      item1 = FactoryGirl.create(:item, illustrator_ids: [illustrator.id] )
      item2 = FactoryGirl.create(:item, illustrator_ids: [illustrator.id] )
      get :show, id: illustrator
      expect(assigns(:illustrator).items).to eq([item1, item2])
    end
  end

  describe "GET #new" do
    it "assigns a new Illustrator to @illustrator" do
      get :new
      expect(assigns(:illustrator)).to be_a_new(Illustrator)
      # expect(assigns(:business).addresses.first).to be_a_new(Address)
    end
    it "renders the illustrator :new template" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new illustrator in the database" do
        expect{
          post :create, illustrator: FactoryGirl.attributes_for(:illustrator)
        }.to change(Illustrator,:count).by(1)
      end
      it "redirects to the illustrators :index page" do
        post :create, illustrator: FactoryGirl.attributes_for(:illustrator)
        expect(response).to redirect_to Illustrator.last
      end
    end

    context "with invalid attributes" do
      it "does not save the new illustrator in the database" do
        expect{
          post :create, illustrator: FactoryGirl.attributes_for(:invalid_illustrator)
        }.to_not change(Illustrator,:count)
      end
      it "re-renders the illustrator :new template" do
        post :create, illustrator: FactoryGirl.attributes_for(:invalid_illustrator)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PUT #update' do
    before :each do
      @illustrator = FactoryGirl.create(:illustrator, firstname: "John", lastname: "Smith")
    end

    context "with valid attributes" do
      it "locates the requested @illustrator" do
        put :update, id: @illustrator, illustrator: FactoryGirl.attributes_for(:illustrator)
        expect(assigns(:illustrator)).to eq(@illustrator)
      end

      it "changes @illustrator's attributes" do
        put :update, id: @illustrator,
          illustrator: FactoryGirl.attributes_for(:illustrator, firstname: "Peter", lastname: "Smith")
        @illustrator.reload
        expect(@illustrator.firstname).to eq("Peter")
        expect(@illustrator.lastname).to eq("Smith")
        expect(@illustrator.name).to eq("Peter Smith")
      end

      it "redirects to the updated illustrator" do
        put :update, id: @illustrator, illustrator: FactoryGirl.attributes_for(:illustrator)
        expect(response).to redirect_to @illustrator
      end
    end

    context "with invalid attributes" do
      it "locates the requested @illustrator" do
        put :update, id: @illustrator, illustrator: FactoryGirl.attributes_for(:invalid_illustrator)
        expect(assigns(:illustrator)).to eq(@illustrator)
      end

      it "does not change @illustrator's attributes" do
        put :update, id: @illustrator,
          illustrator: FactoryGirl.attributes_for(:illustrator, firstname: "Larry", lastname: nil)
        @illustrator.reload
        expect(@illustrator.firstname).to_not eq("Larry")
        expect(@illustrator.lastname).to eq("Smith")
        expect(@illustrator.name).to eq("John Smith")
      end

      it "re-renders the edit method" do
        put :update, id: @illustrator, illustrator: FactoryGirl.attributes_for(:invalid_illustrator)
        expect(response).to render_template :edit
      end
    end

  end

  describe 'DELETE destroy' do
    before :each do
      @illustrator = FactoryGirl.create(:illustrator)
    end

    it "deletes the illustrator" do
      expect{
        delete :destroy, id: @illustrator
      }.to change(Illustrator,:count).by(-1)
    end

    it "redirects to illustrators#index" do
      delete :destroy, id: @illustrator
      expect(response).to redirect_to illustrators_url
    end
  end


end
