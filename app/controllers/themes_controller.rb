class ThemesController < ApplicationController
  load_and_authorize_resource :class => Theme, :instance_name => "theme", :except => :index

  def index
    @themes = Theme.all
  end

  def show
    @theme = Theme.find(params[:id])
    # authorize! :read, @theme
  end

  def new
    @theme = Theme.new
  end

  def create
    @theme = Theme.new(theme_params)

    if @theme.save
      redirect_to @theme
    else
      render 'new'
    end
  end

  def edit
    @theme = Theme.find(params[:id])
  end

  def update
    @theme = Theme.find(params[:id])

    if @theme.update(theme_params)
      redirect_to @theme
    else
      render 'edit'
    end
  end

  def destroy
    @theme = Theme.find(params[:id])
    @theme.destroy

    redirect_to themes_path
  end

  private
  def theme_params
    params.require(:theme).permit(:id, :name, :about, :item_ids => [])
  end


end
