require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do

  before :each do

    @ability = Object.new
    @ability.extend(CanCan::Ability)

  end

  describe "GET #index" do
    it "populates an array of categories" do
      # @ability.can :index, Category
      category = FactoryGirl.create(:category)
      get :index
      expect(assigns(:categories)).to eq([category])
    end
    it "renders the categories :index view" do
      # @ability.can :index, Category
      get :index
      # expect(response).to render_template :index
      assert_template :index
    end
  end

  describe "GET #show" do
    it "assigns the requested category to @category" do
      category = FactoryGirl.create(:category)

      @controller.stub(:current_ability).and_return(@ability)
      @ability.can :read, category

      get :show, id: category
      expect(assigns(:category)).to eq(category)
    end
    it "renders the category :show template" do
      @controller.stub(:current_ability).and_return(@ability)
      @ability.can :read, Category
      get :show, id: FactoryGirl.create(:category)
      expect(response).to render_template :show
    end
    it 'gets the category items' do
      category = FactoryGirl.create(:category)
      item1 = FactoryGirl.create(:item, category_ids: category.id )
      item2 = FactoryGirl.create(:item, category_ids: category.id )

      @controller.stub(:current_ability).and_return(@ability)
      @ability.can :read, category

      get :show, id: category
      expect(assigns(:category).items).to include(item1)
      expect(assigns(:category).items).to include(item2)
    end
  end

  describe "GET #new" do
    it "assigns a new Category to @category" do
      @controller.stub(:current_ability).and_return(@ability)
      @ability.can :create, Category
      get :new
      expect(assigns(:category)).to be_a_new(Category)
      # expect(assigns(:business).addresses.first).to be_a_new(Address)
    end
    it "renders the category :new template" do
      @controller.stub(:current_ability).and_return(@ability)
      @ability.can :create, Category
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new category in the database" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :create, Category
        expect{
          post :create, category: FactoryGirl.attributes_for(:category)
        }.to change(Category,:count).by(1)
      end
      it "redirects to the categories :index page" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :create, Category
        post :create, category: FactoryGirl.attributes_for(:category)
        expect(response).to redirect_to Category.last
      end
    end

    context "with invalid attributes" do
      it "does not save the new category in the database" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :create, Category
        expect{
          post :create, category: FactoryGirl.attributes_for(:invalid_category)
        }.to_not change(Category,:count)
      end
      it "re-renders the category :new template" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :create, Category
        post :create, category: FactoryGirl.attributes_for(:invalid_category)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PUT #update' do
    before :each do
      @item = FactoryGirl.create(:item)
      @category = FactoryGirl.create(:category, name: "Deck building", item_ids: @item.id)
    end

    context "with valid attributes" do
      it "locates the requested @category" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :update, @category
        put :update, id: @category, category: FactoryGirl.attributes_for(:category)
        expect(assigns(:category)).to eq(@category)
      end

      it "changes category's attributes" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :update, @category
        put :update, id: @category,
          category: FactoryGirl.attributes_for(:category, name: "Iello")
        @category.reload
        expect(@category.name).to eq("Iello")
      end

      it "redirects to the updated category" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :update, @category
        put :update, id: @category, category: FactoryGirl.attributes_for(:category)
        expect(response).to redirect_to @category
      end
    end

    context "with invalid attributes" do
      it "locates the requested @category" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :update, @category
        put :update, id: @category, category: FactoryGirl.attributes_for(:invalid_category)
        expect(assigns(:category)).to eq(@category)
      end

      it "does not change @category's attributes" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :update, @category
        put :update, id: @category,
          category: FactoryGirl.attributes_for(:category, name: nil)
        @category.reload
        expect(@category.name).to eq("Deck building")
      end

      it "re-renders the edit method" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :update, @category
        put :update, id: @category, category: FactoryGirl.attributes_for(:invalid_category)
        expect(response).to render_template :edit
      end
    end

  end

  describe 'DELETE destroy' do
    before :each do
      @category = FactoryGirl.create(:category)
    end

    it "deletes the category" do
      @controller.stub(:current_ability).and_return(@ability)
      @ability.can :destroy, @category
      expect{
        delete :destroy, id: @category
      }.to change(Category,:count).by(-1)
    end

    it "redirects to categories#index" do
      @controller.stub(:current_ability).and_return(@ability)
      @ability.can :destroy, @category
      delete :destroy, id: @category
      expect(response).to redirect_to categories_url
    end
  end

end
