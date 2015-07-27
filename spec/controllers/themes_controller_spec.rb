require 'rails_helper'

RSpec.describe ThemesController, type: :controller do

  before :each do

    @ability = Object.new
    @ability.extend(CanCan::Ability)

  end

  describe "GET #index" do
    it "populates an array of themes" do
      # @ability.can :index, Theme
      theme = FactoryGirl.create(:theme)
      get :index
      expect(assigns(:themes)).to eq([theme])
    end
    it "renders the themes :index view" do
      # @ability.can :index, Theme
      get :index
      # expect(response).to render_template :index
      assert_template :index
    end
  end

  describe "GET #show" do
    it "assigns the requested theme to @theme" do
      theme = FactoryGirl.create(:theme)

      @controller.stub(:current_ability).and_return(@ability)
      @ability.can :read, theme

      get :show, id: theme
      expect(assigns(:theme)).to eq(theme)
    end
    it "renders the theme :show template" do
      @controller.stub(:current_ability).and_return(@ability)
      @ability.can :read, Theme
      get :show, id: FactoryGirl.create(:theme)
      expect(response).to render_template :show
    end
    it 'gets the theme items' do
      theme = FactoryGirl.create(:theme)
      item1 = FactoryGirl.create(:item, theme_ids: theme.id )
      item2 = FactoryGirl.create(:item, theme_ids: theme.id )

      @controller.stub(:current_ability).and_return(@ability)
      @ability.can :read, theme

      get :show, id: theme
      expect(assigns(:theme).items).to include(item1)
      expect(assigns(:theme).items).to include(item2)
    end
  end

  describe "GET #new" do
    it "assigns a new Theme to @theme" do
      @controller.stub(:current_ability).and_return(@ability)
      @ability.can :create, Theme
      get :new
      expect(assigns(:theme)).to be_a_new(Theme)
      # expect(assigns(:business).addresses.first).to be_a_new(Address)
    end
    it "renders the theme :new template" do
      @controller.stub(:current_ability).and_return(@ability)
      @ability.can :create, Theme
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new theme in the database" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :create, Theme
        expect{
          post :create, theme: FactoryGirl.attributes_for(:theme)
        }.to change(Theme,:count).by(1)
      end
      it "redirects to the themes :index page" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :create, Theme
        post :create, theme: FactoryGirl.attributes_for(:theme)
        expect(response).to redirect_to Theme.last
      end
    end

    context "with invalid attributes" do
      it "does not save the new theme in the database" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :create, Theme
        expect{
          post :create, theme: FactoryGirl.attributes_for(:invalid_theme)
        }.to_not change(Theme,:count)
      end
      it "re-renders the theme :new template" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :create, Theme
        post :create, theme: FactoryGirl.attributes_for(:invalid_theme)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PUT #update' do
    before :each do
      @item = FactoryGirl.create(:item)
      @theme = FactoryGirl.create(:theme, name: "Deck building", item_ids: @item.id)
    end

    context "with valid attributes" do
      it "locates the requested @theme" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :update, @theme
        put :update, id: @theme, theme: FactoryGirl.attributes_for(:theme)
        expect(assigns(:theme)).to eq(@theme)
      end

      it "changes theme's attributes" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :update, @theme
        put :update, id: @theme,
          theme: FactoryGirl.attributes_for(:theme, name: "Iello")
        @theme.reload
        expect(@theme.name).to eq("Iello")
      end

      it "redirects to the updated theme" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :update, @theme
        put :update, id: @theme, theme: FactoryGirl.attributes_for(:theme)
        expect(response).to redirect_to @theme
      end
    end

    context "with invalid attributes" do
      it "locates the requested @theme" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :update, @theme
        put :update, id: @theme, theme: FactoryGirl.attributes_for(:invalid_theme)
        expect(assigns(:theme)).to eq(@theme)
      end

      it "does not change @theme's attributes" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :update, @theme
        put :update, id: @theme,
          theme: FactoryGirl.attributes_for(:theme, name: nil)
        @theme.reload
        expect(@theme.name).to eq("Deck building")
      end

      it "re-renders the edit method" do
        @controller.stub(:current_ability).and_return(@ability)
        @ability.can :update, @theme
        put :update, id: @theme, theme: FactoryGirl.attributes_for(:invalid_theme)
        expect(response).to render_template :edit
      end
    end

  end

  describe 'DELETE destroy' do
    before :each do
      @theme = FactoryGirl.create(:theme)
    end

    it "deletes the theme" do
      @controller.stub(:current_ability).and_return(@ability)
      @ability.can :destroy, @theme
      expect{
        delete :destroy, id: @theme
      }.to change(Theme,:count).by(-1)
    end

    it "redirects to themes#index" do
      @controller.stub(:current_ability).and_return(@ability)
      @ability.can :destroy, @theme
      delete :destroy, id: @theme
      expect(response).to redirect_to themes_url
    end
  end

end
