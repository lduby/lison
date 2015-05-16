class IllustratorsController < ApplicationController

  def index
    @illustrators = Illustrator.all
  end

  def show
    @illustrator = Illustrator.find(params[:id])
  end

  def new
    @illustrator = Illustrator.new
  end

  def create
    @illustrator = Illustrator.new(illustrator_params)

    if @illustrator.save
      redirect_to @illustrator
    else
      render 'new'
    end
  end

  def edit
    @illustrator = Illustrator.find(params[:id])
  end

  def update
    @illustrator = Illustrator.find(params[:id])

    if @illustrator.update(illustrator_params)
      redirect_to @illustrator
    else
      render 'edit'
    end
  end

  def destroy
    @illustrator = Illustrator.find(params[:id])
    @illustrator.destroy

    redirect_to illustrators_path
  end

  private
  def illustrator_params
    params.require(:illustrator).permit(:firstname, :lastname, :about, :item_ids => [])
  end

end
