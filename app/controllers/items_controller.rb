class ItemsController < ApplicationController
   load_and_authorize_resource :class => Item, :instance_name => "item", :except => [:index, :list]

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
      if params[:category_id]
         @category = Category.find(params[:category_id])
         @items = @category.items
      end
   end

   def show
      @item = Item.find(params[:id])
   end

   def new
      @item = Item.new
      @item.authors.build
      @item.illustrators.build
      @item.themes.build
      @item.categories.build
      @authors = Author.all
      @illustrators = Illustrator.all
      @publishers = Publisher.all
      @collections = Collection.all
      @themes = Theme.all
      @categories = Category.all
   end

   def create

      ## Allows to create a new item even if the author already exists
      if !params[:item][:authors_attributes].nil?
         if params[:item][:authors_attributes].any?
            authors_count = 0
            @authors = []
            params[:item][:authors_attributes].each do |author|
               @author = Author.find_by_firstname_and_lastname(author[1]["firstname"], author[1]["lastname"])
               if @author
                  puts "Author already exists"
                  params[:item][:author_ids] << @author.id.to_s
                  params[:item][:authors_attributes].delete("#{authors_count}")
               end
               authors_count+=1
            end
         end
      end

      ## Allows to create a new item even if the illustrator already exists
      if !params[:item][:illustrators_attributes].nil?
         if params[:item][:illustrators_attributes].any?
            illustrators_count = 0
            @illustrators = []
            params[:item][:illustrators_attributes].each do |illustrator|
               @illustrator = Illustrator.find_by_firstname_and_lastname(illustrator[1]["firstname"], illustrator[1]["lastname"])
               if @illustrator
                  puts "Illustrator already exists"
                  params[:item][:illustrator_ids] << @illustrator.id.to_s
                  params[:item][:illustrators_attributes].delete("#{illustrators_count}")
               end
               illustrators_count+=1
            end
         end
      end

      ## Allows to create a new item even if the theme already exists
      if !params[:item][:themes_attributes].nil?
         if params[:item][:themes_attributes].any?
            themes_count = 0
            @themes = []
            params[:item][:themes_attributes].each do |theme|
               @theme = Theme.find_by_name(theme[1]["name"])
               if @theme
                  puts "Theme already exists"
                  params[:item][:theme_ids] << @theme.id.to_s
                  params[:item][:themes_attributes].delete("#{themes_count}")
               end
               themes_count+=1
            end
         end
      end

      ## Allows to create a new item even if the category already exists
      if !params[:item][:categories_attributes].nil?
         if params[:item][:categories_attributes].any?
            categories_count = 0
            @categories = []
            params[:item][:categories_attributes].each do |category|
               @category = Category.find_by_name(category[1]["name"])
               if @category
                  puts "Category already exists"
                  params[:item][:category_ids] << @category.id.to_s
                  params[:item][:categories_attributes].delete("#{categories_count}")
               end
               categories_count+=1
            end
         end
      end

      ## Creates the new item
      @item = Item.new(item_params)

      # no need to add code for habtm associations, Rails do it automatically because of the HATBM relation

      # Redirection
      if @item.save
         redirect_to @item
      else
         render 'new'
      end
   end

   def edit
      @item = Item.find(params[:id])
      @item.authors.build
      @item.illustrators.build
      @item.themes.build
      @item.categories.build
      @authors = Author.all - @item.authors
      #  @illustrators = Illustrator.all
      @publishers = Publisher.all
      @collections = Collection.all
      #  @themes = Theme.all
      #  @categories = Category.all
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
      params.require(:item).permit(:title, :publisher_id, :collection_id, :author_ids => [], :illustrator_ids => [], :theme_ids => [], :category_ids => [], authors_attributes: [:id, :firstname, :lastname, :about, :_destroy], illustrators_attributes: [:id, :firstname, :lastname, :about, :_destroy], themes_attributes: [:id, :name, :about, :_destroy], categories_attributes: [:id, :name, :about, :_destroy])
      #  params.require(:item).permit(:title, :publisher_id, :collection_id, :author_ids => [], :illustrator_ids => [], publisher_attributes: [:id, :name, :about])

   end




end
