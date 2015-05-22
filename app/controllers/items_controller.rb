class ItemsController < ApplicationController

  def index
    @items = Item.all
  end

  def list
    if params[:author_id]
      @author = Author.find(params[:author_id])
      @items = @author.items
    end
    if params[:illustrator_id]
      @illustrator = Illustrator.find(params[:illustrator_id])
      @items = @illustrator.items
    end
    if params[:publisher_id]
      @publisher = Publisher.find(params[:publisher_id])
      @items = @publisher.items
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
    @authors = Author.all
    @illustrators = Illustrator.all
    @publishers = Publisher.all
  end

  def create
    @item = Item.new(item_params)
    # no need to add code for habtm associations, Rails do it automatically because of the HATBM relation
    if @item.save
      redirect_to @item
    else
      render 'new'
    end
  end

  def edit
    @item = Item.find(params[:id])
    @authors = Author.all
    @illustrators = Illustrator.all
    @publishers = Publisher.all
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
    params.require(:item).permit(:title, :publisher_id, :author_ids => [], :illustrator_ids => [])
  end



end
