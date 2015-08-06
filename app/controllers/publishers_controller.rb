class PublishersController < ApplicationController

  load_and_authorize_resource :class => Publisher, :instance_name => "publisher", :except => :index

  def index
    @publishers = Publisher.all
  end

  def show
    @publisher = Publisher.find(params[:id])
  end

  def new
    @publisher = Publisher.new
    @publisher.collections.build
  end

  def create
    @publisher = Publisher.new(publisher_params)

    if @publisher.save
      redirect_to @publisher
    else
      render 'new'
    end
  end

  def edit
    @publisher = Publisher.find(params[:id])
    @publisher.collections.build
  end

  def update
    @publisher = Publisher.find(params[:id])

    if @publisher.update(publisher_params)
      redirect_to @publisher
    else
      render 'edit'
    end
  end

  def destroy
    @publisher = Publisher.find(params[:id])
    @publisher.destroy

    redirect_to publishers_path
  end

  private
  def publisher_params
    params.require(:publisher).permit(:name, :about, :item_ids => [], :collection_ids => [], collections_attributes: [:id, :name, :about, :_destroy])
  end


end
