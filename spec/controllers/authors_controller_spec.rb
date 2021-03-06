require 'rails_helper'

RSpec.describe AuthorsController, type: :controller do

  before :each do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
  end

  describe "GET #index" do
    it "populates an array of authors" do
      author = FactoryGirl.create(:author)
      get :index
      expect(assigns(:authors)).to eq([author])
    end
    it "renders the authors :index view" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    it "assigns the requested author to @author" do
      author = FactoryGirl.create(:author)
      @controller.stub(:current_ability).and_return(@ability)
      @ability.can :read, author
      get :show, id: author
      expect(assigns(:author)).to eq(author)
    end
    it "renders the author :show template" do
      @controller.stub(:current_ability).and_return(@ability)
      @ability.can :read, Author
      get :show, id: FactoryGirl.create(:author)
      expect(response).to render_template :show
    end
    it 'gets the author items' do
      author = FactoryGirl.create(:author)
      item1 = FactoryGirl.create(:item, author_ids: [author.id] )
      item2 = FactoryGirl.create(:item, author_ids: [author.id] )
      @controller.stub(:current_ability).and_return(@ability)
      @ability.can :read, author
      get :show, id: author
      expect(assigns(:author).items).to eq([item1, item2])
    end
  end

  describe "GET #new" do
    it "assigns a new Author to @author" do
      @controller.stub(:current_ability).and_return(@ability)
      @ability.can :create, Author
      get :new
      expect(assigns(:author)).to be_a_new(Author)
      # expect(assigns(:business).addresses.first).to be_a_new(Address)
    end
    it "renders the author :new template" do
      @controller.stub(:current_ability).and_return(@ability)
      @ability.can :create, Author
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new author in the database" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :create, Author
        expect{
          post :create, author: FactoryGirl.attributes_for(:author)
        }.to change(Author,:count).by(1)
      end
      it "redirects to the authors :index page" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :create, Author
        post :create, author: FactoryGirl.attributes_for(:author)
        expect(response).to redirect_to Author.last
      end
    end

    context "with invalid attributes" do
      it "does not save the new author in the database" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :create, Author
        expect{
          post :create, author: FactoryGirl.attributes_for(:invalid_author)
        }.to_not change(Author,:count)
      end
      it "re-renders the author :new template" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :create, Author
        post :create, author: FactoryGirl.attributes_for(:invalid_author)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PUT #update' do
    before :each do
      @author = FactoryGirl.create(:author, firstname: "John", lastname: "Smith")
    end

    context "with valid attributes" do
      it "locates the requested @author" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :update, @author
        put :update, id: @author, author: FactoryGirl.attributes_for(:author)
        expect(assigns(:author)).to eq(@author)
      end

      it "changes @author's attributes" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :update, @author
        put :update, id: @author,
          author: FactoryGirl.attributes_for(:author, firstname: "Peter", lastname: "Smith")
        @author.reload
        expect(@author.firstname).to eq("Peter")
        expect(@author.lastname).to eq("Smith")
        expect(@author.name).to eq("Peter Smith")
      end

      it "redirects to the updated author" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :update, @author
        put :update, id: @author, author: FactoryGirl.attributes_for(:author)
        expect(response).to redirect_to @author
      end
    end

    context "with invalid attributes" do
      it "locates the requested @author" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :update, @author
        put :update, id: @author, author: FactoryGirl.attributes_for(:invalid_author)
        expect(assigns(:author)).to eq(@author)
      end

      it "does not change @author's attributes" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :update, @author
        put :update, id: @author,
          author: FactoryGirl.attributes_for(:author, firstname: "Larry", lastname: nil)
        @author.reload
        expect(@author.firstname).to_not eq("Larry")
        expect(@author.lastname).to eq("Smith")
        expect(@author.name).to eq("John Smith")
      end

      it "re-renders the edit method" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :update, @author
        put :update, id: @author, author: FactoryGirl.attributes_for(:invalid_author)
        expect(response).to render_template :edit
      end
    end

  end

  describe 'DELETE destroy' do
    before :each do
      @author = FactoryGirl.create(:author)
    end

    it "deletes the author" do
      @controller.stub(:current_ability).and_return(@ability)
      @ability.can :destroy, @author
      expect{
        delete :destroy, id: @author
      }.to change(Author,:count).by(-1)
    end

    it "redirects to authors#index" do
      @controller.stub(:current_ability).and_return(@ability)
      @ability.can :destroy, @author
      delete :destroy, id: @author
      expect(response).to redirect_to authors_url
    end
  end


end
