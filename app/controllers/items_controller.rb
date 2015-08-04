class ItemsController < ApplicationController

  def index
    @items = Item.all
  end

  def list
    if params[:category_id]
      @category = Category.find(params[:category_id])
      @items = @category.items
    end
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
    if params[:collection_id]
      @collection = Collection.find(params[:collection_id])
      @items = @collection.items
    end
      if params[:theme_id]
        @theme = Theme.find(params[:theme_id])
        @items = @theme.items
      end
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
    #@item.publisher.build
    @authors = Author.all
    @illustrators = Illustrator.all
    @publishers = Publisher.all
    @collections = Collection.all
    @themes = Theme.all
    @categories = Category.all
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
    #@item.publisher.build
    @authors = Author.all
    @illustrators = Illustrator.all
    @publishers = Publisher.all
    @collections = Collection.all
    @themes = Theme.all
    @categories = Category.all
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      # Removing the collection if the publisher changes
      if !item_params[:publisher_id].nil? && item_params[:publisher_id]!=@item.publisher_id
        if !@item.collection.nil?
          @item.collection.delete()
        end
      end
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
    params.require(:item).permit(:title, :publisher_id, :collection_id, :author_ids => [], :illustrator_ids => [], :theme_ids => [], :category_ids => [])
  #  params.require(:item).permit(:title, :publisher_id, :collection_id, :author_ids => [], :illustrator_ids => [], publisher_attributes: [:id, :name, :about])

  end




end
