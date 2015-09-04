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
            @authors_attributes = params[:item][:authors_attributes]
            @authors_attributes.each do |author|
               @author = Author.find_by_firstname_and_lastname(author[1]["firstname"], author[1]["lastname"])
               if @author
                  if params[:item][:author_ids].nil?
                     params[:item][:author_ids] = [""]
                  end
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
            @illustrators_attributes = params[:item][:illustrators_attributes]
            @illustrators_attributes.each do |illustrator|
               @illustrator = Illustrator.find_by_firstname_and_lastname(illustrator[1]["firstname"], illustrator[1]["lastname"])
               if @illustrator
                  if params[:item][:illustrator_ids].nil?
                     params[:item][:illustrator_ids] = [""]
                  end
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
            @themes_attributes = params[:item][:themes_attributes]
            @themes_attributes.each do |theme|
               @theme = Theme.find_by_name(theme[1]["name"])
               if @theme
                  if params[:item][:theme_ids].nil?
                     params[:item][:theme_ids] = [""]
                  end
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
            @categories_attributes = params[:item][:categories_attributes]
            @categories_attributes.each do |category|
               @category = Category.find_by_name(category[1]["name"])
               if @category
                  if params[:item][:category_ids].nil?
                     params[:item][:category_ids] = [""]
                  end
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
      # Checks if the previously associated authors has been updated
      if !params[:item][:authors_attributes].nil?
         if params[:item][:authors_attributes].any?
            authors_count = 0
            @authors_attributes = params[:item][:authors_attributes]
            @authors_attributes.each do |author|
               if !author[1]["id"].nil?
                  # One of the associated authors is updated
                  @author = Author.find(author[1]["id"])
                  @author.update(:firstname => author[1]["firstname"], :lastname => author[1]["lastname"], :about => author[1]["about"])
                  params[:item][:authors_attributes].delete("#{authors_count}")
                  if author[1]["_destroy"] == "0"
                     if params[:item][:author_ids].nil?
                        params[:item][:author_ids] = [""]
                     end
                     params[:item][:author_ids] << @author.id.to_s
                  end
               else
                  #  New association with an author
                  @author = Author.find_by_firstname_and_lastname(author[1]["firstname"], author[1]["lastname"])
                  if @author
                     params[:item][:author_ids] << @author.id.to_s
                     params[:item][:authors_attributes].delete("#{authors_count}")
                  end
               end
               authors_count += 1
            end
         end
      end
      # Checks if the previously associated illustrators has been updated
      if !params[:item][:illustrators_attributes].nil?
         if params[:item][:illustrators_attributes].any?
            illustrators_count = 0
            @illustrators_attributes = params[:item][:illustrators_attributes]
            @illustrators_attributes.each do |illustrator|
               if !illustrator[1]["id"].nil?
                  # One of the associated illustrators is updated
                  @illustrator = Illustrator.find(illustrator[1]["id"])
                  @illustrator.update(:firstname => illustrator[1]["firstname"], :lastname => illustrator[1]["lastname"], :about => illustrator[1]["about"])
                  params[:item][:illustrators_attributes].delete("#{illustrators_count}")
                  if illustrator[1]["_destroy"] == "0"
                     if params[:item][:illustrator_ids].nil?
                        params[:item][:illustrator_ids] = [""]
                     end
                     params[:item][:illustrator_ids] << @illustrator.id.to_s
                  end
               else
                  #  New association with an illustrator
                  @illustrator = Illustrator.find_by_firstname_and_lastname(illustrator[1]["firstname"], illustrator[1]["lastname"])
                  if @illustrator
                     params[:item][:illustrator_ids] << @illustrator.id.to_s
                     params[:item][:illustrators_attributes].delete("#{illustrators_count}")
                  end
               end
               illustrators_count += 1
            end
         end
      end
      # Checks if the previously associated themes has been updated
      if !params[:item][:themes_attributes].nil?
         if params[:item][:themes_attributes].any?
            themes_count = 0
            @themes_attributes = params[:item][:themes_attributes]
            @themes_attributes.each do |theme|
               if !theme[1]["id"].nil?
                  # One of the associated themes is updated
                  @theme = Theme.find(theme[1]["id"])
                  @theme.update(:name => theme[1]["name"], :about => theme[1]["about"])
                  params[:item][:themes_attributes].delete("#{themes_count}")
                  if theme[1]["_destroy"] == "0"
                     if params[:item][:theme_ids].nil?
                        params[:item][:theme_ids] = [""]
                     end
                     params[:item][:theme_ids] << @theme.id.to_s
                  end
               else
                  #  New association with an theme
                  @theme = Theme.find_by_name(theme[1]["name"])
                  if @theme
                     params[:item][:theme_ids] << @theme.id.to_s
                     params[:item][:themes_attributes].delete("#{themes_count}")
                  end
               end
               themes_count += 1
            end
         end
      end
      # Checks if the previously associated categories has been updated
      if !params[:item][:categories_attributes].nil?
         if params[:item][:categories_attributes].any?
            categories_count = 0
            @categories_attributes = params[:item][:categories_attributes]
            @categories_attributes.each do |category|
               if !category[1]["id"].nil?
                  # One of the associated categories is updated
                  @category = Category.find(category[1]["id"])
                  @category.update(:name => category[1]["name"], :about => category[1]["about"])
                  params[:item][:categories_attributes].delete("#{categories_count}")
                  if category[1]["_destroy"] == "0"
                     if params[:item][:category_ids].nil?
                        params[:item][:category_ids] = [""]
                     end
                     params[:item][:category_ids] << @category.id.to_s
                  end
               else
                  #  New association with an category
                  @category = Category.find_by_name(category[1]["name"])
                  if @category
                     params[:item][:category_ids] << @category.id.to_s
                     params[:item][:categories_attributes].delete("#{categories_count}")
                  end
               end
               categories_count += 1
            end
         end
      end


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
