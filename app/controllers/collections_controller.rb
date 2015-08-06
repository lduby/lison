class CollectionsController < ApplicationController
  load_and_authorize_resource :class => Collection, :instance_name => "collection", :except => :index

  def index
    @collections = Collection.all
  end

  def list
    if params[:publisher_id]
      @publisher = Publisher.find(params[:publisher_id])
      @collections = @publisher.collections
    end
  end


  def show
    @collection = Collection.find(params[:id])
    # authorize! :read, @collection
  end

  def new
    @collection = Collection.new
    @publishers = Publisher.all
  end

  def create
    @collection = Collection.new(collection_params)

    if @collection.save
      redirect_to @collection
    else
      render 'new'
    end
  end

  def edit
    @collection = Collection.find(params[:id])
    @publishers = Publisher.all
  end

  def update
    @collection = Collection.find(params[:id])

    if @collection.update(collection_params)
      redirect_to @collection
    else
      render 'edit'
    end
  end

  def destroy
    @collection = Collection.find(params[:id])
    @collection.destroy

    redirect_to collections_path
  end

  private
  def collection_params
    params.require(:collection).permit(:id, :name, :about, :publisher_id, :item_ids => [])
  end


end
