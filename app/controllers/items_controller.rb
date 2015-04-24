class ItemsController < ApplicationController

  def index
    # if params[:author_id]
    #   @items = (Author.find(params[:author_id])).items
    # else
      @items = Item.all
    # end
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
    @authors = Author.all
  end

  def create
    @item = Item.new(item_params)
    # no need to add code for authors associations, Rails do it automatically because of the HATBM relation
    if @item.save
      redirect_to @item
    else
      render 'new'
    end
  end

  def edit
    @item = Item.find(params[:id])
    @authors = Author.all
  end

  def update
    @item = Item.find(params[:id])

    if @item.update(item_params)
      redirect_to @item
    else
      render 'edit'
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    redirect_to items_path
  end

  private
  def item_params
    params.require(:item).permit(:title, :author_ids => [])
  end



end
