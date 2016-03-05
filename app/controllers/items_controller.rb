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
       puts @item
       respond_to :html, :js
   end

   def new
       puts params[:item]
      @item = Item.new
      @item.authors.build
      @item.illustrators.build
      @item.themes.build
      @item.categories.build
      @item.build_publisher
      @item.build_collection
      # @item.publisher = Publisher.new
      # @item.collection = Collection.new
      @authors = Author.all
      @illustrators = Illustrator.all
      @publishers = Publisher.all
      @collections = Collection.all
      @themes = Theme.all
      @categories = Category.all
   end

   def create
#       byebug
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

      ## Allows to create a new item even if the publisher and the collection already exists
       @error_raised = false
      @associating_pub_to_coll = false
      if !params[:item][:publisher_attributes].nil?
         # "the publisher attributes are not null"
         if params[:item][:publisher_attributes]["name"]!=""
            # "A publisher has been filled in"
            @publisher_attributes = params[:item][:publisher_attributes]
            @publisher = Publisher.find_by_name(@publisher_attributes["name"])
            if !params[:item][:collection_attributes].nil?
               # "Collection attributes are not null"
               if params[:item][:collection_attributes]["name"]!=""
                  # "A collection has been filled in"
                  @collection_attributes = params[:item][:collection_attributes]
                  @collection = Collection.find_by_name(@collection_attributes["name"])
                  if @publisher
                     # "The publisher already exists"
                     if @collection
                        # "The collection already exists"
                        if !@collection.publisher.nil?
                           # "Collection has no publisher"
                            if @collection.publisher.id == @publisher.id
                              # "The publisher and the collection are associated"
                              params[:item][:collection_id] = @collection.id.to_s
                              params[:item][:collection_attributes] = {"name"=>"", "about"=>"", "id"=>""}
                           else
                              # "The collection is associated to another publisher"
                                flash[:alert] = "The collection is associated to another publisher"
                                @error_raised = true
                           end
                        else
                           # "The publisher and the collection are not associated"
                            flash[:alert] = "The collection is associated to another publisher."
                            @error_raised = true
                        end
                     else
                        # "The collection does not exist"
                        params[:item][:collection_attributes] = {"name"=>@collection_attributes["name"], "about"=>@collection_attributes["about"], "publisher_id" => @publisher.id.to_s}
                     end
                     params[:item][:publisher_id] = @publisher.id.to_s
                     params[:item][:publisher_attributes] = {"name"=>"", "about"=>""}
                  else
                     # "The publisher does not exist"
                     if @collection
                        # "The collection already exists"
                        if !@collection.publisher.nil?
                           # "The collection is associated to an existing publisher"
                            flash[:alert] = "The collection is already associated to an existing publisher."
                            @error_raised = true
                        else
                           # "The collection has no publisher => NOT NORMAL ! THIS SITUATION IS NOT SUPPOSED TO OCCUR"
                           params[:item][:collection_id] = @collection.id.to_s
                           params[:item][:collection_attributes] = {"name"=>"", "about"=>""}
                           @associating_pub_to_coll = true
                        end
                     else
                        # "The collection does not exist"
                        # "The collection and the publisher must be associated"
                        # "new publisher and new collection for the new item"
                        @associating_pub_to_coll = true
                     end
                  end
               else
                  # "No collection has been filled_in"
                  if @publisher
                     # "The publisher already exists"
                     params[:item][:publisher_id] = @publisher.id.to_s
                     params[:item][:publisher_attributes] = {"name"=>"", "about"=>""}
                  end
               end
            else
               # "Collection attributes are null"
               if @publisher
                  # "The publisher already exists"
                  params[:item][:publisher_id] = @publisher.id.to_s
                  params[:item][:publisher_attributes] = {"name"=>"", "about"=>""}
               end
            end
         else
            # "No publisher has been filled_in"
            if !params[:item][:collection_attributes].nil?
               if params[:item][:collection_attributes]["name"]!=""
                  # "A collection has been filled_in"
                  @collection_attributes = params[:item][:collection_attributes]
                  @collection = Collection.find_by_name(@collection_attributes["name"])
                  if @collection
                     # "The collection already exists"
                     if !@collection.publisher.nil?
                        # "The collection is associated to a publisher"
                        params[:item][:publisher_id] = @collection.publisher.id.to_s
                        params[:item][:collection_id] = @collection.id.to_s
                        params[:item][:collection_attributes] = {"name"=>"", "about"=>""}
                     else
                        # "The collection has no publisher to be linked to"
                         flash[:alert] = "The collection exists but has no publisher. A publisher has to be filled in."
#                         render 'new' and return
                         @error_raised = true
                     end
                  else
#                      params[:item][:collection_attributes] = {"name"=>"", "about"=>""}
                      flash[:alert] = "A new collection needs a publisher to be created."
#                      render 'new' and return
                      @error_raised = true
                  end
               end
            end
         end
      else
         # "the publisher attributes are null"
         if !params[:item][:collection_attributes].nil?
            if params[:item][:collection_attributes]["name"]!=""
               # "A collection has been filled_in"
               @collection_attributes = params[:item][:collection_attributes]
               @collection = Collection.find_by_name(@collection_attributes["name"])
               if @collection
                  # "The collection already exists"
                  if !@collection.publisher.nil?
                     # "The collection is associated to a publisher"
                     params[:item][:publisher_id] = @collection.publisher.id.to_s
                     params[:item][:collection_id] = @collection.id.to_s
                     params[:item][:collection_attributes] = {"name"=>"", "about"=>""}
                  else
                     # "The collection has no publisher to be linked to"
                      flash[:alert] = "The collection exists but has no publisher. A publisher has to be filled in."
                      @error_raised = true
                  end
               else
                   flash[:alert] = "A new collection needs a publisher to be created."
                   @error_raised = true
               end
            end
         end
      end

       ## Creates the new item
       @item = Item.new(item_params)
       
       if !@error_raised 

          # no need to add code for habtm associations, Rails do it automatically because of the HATBM relation

          # Redirection
          if @item.save
             if @associating_pub_to_coll
                # Associating a new collection to a new publisher
                if !@item.publisher.nil?
                   @item.publisher.collections << @item.collection
                # else
                #    puts "No publisher for newly created item whereas an association between publisher and collection has been asked"
                end
             end
             redirect_to @item
          else
              puts params[:item].inspect
              @item.authors.build
              @item.illustrators.build
              @item.themes.build
              @item.categories.build
              if !params[:item][:publisher_attributes].nil?
                @item.build_publisher(:name => params[:item][:publisher_attributes]["name"], :about => params[:item][:publisher_attributes]["about"])
              else
                  @item.build_publisher
              end
              if !params[:item][:collection_attributes].nil?
                @item.build_collection(:name => params[:item][:collection_attributes]["name"], :about => params[:item][:collection_attributes]["about"])
              else
                  @item.build_collection
              end
#              @authors = Author.all
             render 'new'
          end
       else 
           @item.authors.build
           @item.illustrators.build
           @item.themes.build
           @item.categories.build
           if !params[:item][:publisher_attributes].nil?
               @item.build_publisher(:name => params[:item][:publisher_attributes]["name"], :about => params[:item][:publisher_attributes]["about"])
           else
               @item.build_publisher
           end
           if !params[:item][:collection_attributes].nil?
               @item.build_collection(:name => params[:item][:collection_attributes]["name"], :about => params[:item][:collection_attributes]["about"])
           else
               @item.build_collection
           end
#           if params[:item][:collection_attributes]["name"] != "" 
#               @item.collection = Collection.new(:name => params[:item][:collection_attributes]["name"]  )
#           end
           render 'new'
       end
   end

   def edit
      @item = Item.find(params[:id])
      @item.authors.build
      @item.illustrators.build
      @item.themes.build
      @item.categories.build
      @item.build_publisher
      @item.build_collection
      # if @item.publisher.nil?
      #    @item.publisher = Publisher.new
      # end
      # if @item.collection.nil?
      #    @item.collection = Collection.new
      # end
      @authors = Author.all - @item.authors
      @illustrators = Illustrator.all - @item.illustrators
      @publishers = Publisher.all - [@item.publisher]
      @collections = @item.publisher.collections - [@item.collection]
      @themes = Theme.all - @item.themes
      @categories = Category.all - @item.categories
   end

   def update
#       byebug
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

      ## Checks if the publisher has been updated
       @error_raised = false
      @associating_coll_to_pub = false
      @no_publisher = false
      # puts "Received params : #{params[:item]}"
      if !params[:item][:publisher_attributes].nil?
         if params[:item][:publisher_attributes]["name"] != ""
         puts "1. A publisher has been filled in"
         @publisher_attributes = params[:item][:publisher_attributes]
         @publisher_to_be_created = false
         if !params[:item][:publisher_attributes]["id"].nil?
            puts "2. The publisher has an id"
            @publisher = Publisher.find_by_id(@publisher_attributes["id"])
            if @publisher
               if @publisher.name != @publisher_attributes["name"]
                  puts "3. The name of the publisher has been changed"
                  @newpublisher = Publisher.find_by_name(@publisher_attributes["name"])
                  if @newpublisher
                     puts "4. The new publisher already exists"
                     puts "changing publisher id #{params[:item][:publisher_id]} by #{@newpublisher.id.to_s}"
                     params[:item][:publisher_id] = @newpublisher.id.to_s
                     # params[:item][:publisher_attributes] = {"name" => "", "about" => "", "id"=>"#{@publisher.id}"}
                     params[:item][:publisher_attributes] = {"name" => "", "about" => "", "id"=>""}
                  else
                     puts "5. The new publisher does not exist"
                     params[:item][:publisher_id] = ""
                     # params[:item][:publisher_attributes] = {"name" => @publisher_attributes["name"], "about" => @publisher_attributes["about"], "id"=>@publisher.id}
                     params[:item][:publisher_attributes] = {"name" => @publisher_attributes["name"], "about" => @publisher_attributes["about"], "id"=>""}
                     @publisher_to_be_created = true
                  end
               else
                  puts "6. The name of the publisher has not been changed"
                  params[:item][:publisher_attributes] = {"name" => "", "about" => "", "id"=>""}
               end
            # else
            #    puts "publisher not found"
            end
         else
            puts "7. The publisher has no id, no publisher was defined before the item was edited"
            @publisher = Publisher.find_by_name(@publisher_attributes["name"])
            if @publisher
               puts "8.The publisher to be associated already exists"
               params[:item][:publisher_id] = @publisher.id.to_s
               params[:item][:publisher_attributes] = {"name"=>"", "about"=>"", "id"=>""}
            else
               puts "9. The publisher has to be created"
                params[:item][:publisher_id] = ""
               params[:item][:publisher_attributes] = {"name" => @publisher_attributes["name"], "about" => @publisher_attributes["about"]}
               @publisher_to_be_created = true
            end
         end
      else
         @no_publisher = true
      end
         if !params[:item][:collection_attributes].nil?
            if params[:item][:collection_attributes]["name"] != ""
               puts "10. A collection has been filled in"
               @collection_attributes = params[:item][:collection_attributes]
               if !params[:item][:collection_attributes]["id"].nil?
                  puts "11. The collection has an id"
                  @collection = Collection.find_by_id(params[:item][:collection_id])
                  if @collection
                     if @collection.name != @collection_attributes["name"]
                        puts "12. The name of the collection has been changed"
                        @newcollection = Collection.find_by_name(@collection_attributes["name"])
                        if @newcollection
                           puts "13. The new collection already exists"
                           if @no_publisher
                              if @newcollection.publisher.nil?
                                 puts "13.3 No publisher and the chosen collection has no publisher"
                                  flash[:alert] = "The collection must be associated to a publisher"
                                  @error_raised = true
                              else
                                 puts "13.4 No publisher but the chosen collection has a publisher"
                                 params[:item][:collection_id] = @newcollection.id.to_s
                                 params[:item][:collection_attributes] = {"name" => "", "about" => "", "id"=>""}
                                 params[:item][:publisher_id] = @newcollection.publisher.id.to_s
                                 params[:item][:publisher_attributes] = {"name" => "", "about" => "", "id"=>""}
                              end
                           elsif !@publisher_to_be_created
                              puts "13.1 The publisher already exists"
                              if @newcollection.publisher.id.to_s == params[:item][:publisher_id]
                                 puts "14. The publisher of the collection matches the filled_in publisher"
                                 params[:item][:collection_id] = @newcollection.id.to_s
                                 params[:item][:collection_attributes] = {"name" => "", "about" => "", "id"=>""}
                              else
                                 puts "15. The publisher of the collection does not match the filled_in publisher"
                                 flash[:alert] = "The collection is associated to another publisher"
                                 @error_raised = true
                              end
                           else
                              puts "13.2 The publisher has to be created"
                              if @newcollection.publisher.nil?
                                 puts "13.2.1 The collection has no publisher"
                                 params[:item]["collection_id"] = @newcollection.id
#                                  params[:item]["collection_id"] = ""
                                  params[:item][:collection_attributes] = {"name" => "", "about" => "", "id" => ""}
                                 @associating_coll_to_pub = true
                              else
                                 puts "13.2.2 The collection already has a publisher"
                                 flash[:alert] = "The collection is already associated to an existing publisher"
                                  @error_raised = true
                              end
                           end
                        else
                           puts "16. The new collection has to be created"
                           if @no_publisher
                              puts "16.3 No publisher so the new collection can't be associated to a publisher to be created"
                              flash[:alert] = "A new collection needs a publisher to be created"
                               @error_raised = true
                           elsif !@publisher_to_be_created
                              puts "16.1 The new publisher already exists"
                              params[:item][:collection_attributes]["publisher_id"] = params[:item][:publisher_id]
                           else
                              puts "16.2 The new publisher has to be created"
                              # "the link between the collection and the publisher has to be made after the creation"
                              @associating_coll_to_pub = true
                           end
                           params[:item][:collection_attributes]["id"] = ""
                           params[:item][:collection_id] = ""
                        end
                     else
                        puts "17. The name of the collection has not been changed"
                        if @no_publisher
                            puts "17.1 No publisher and unchanged collection"
                            if !@collection.publisher.nil?
                                puts "17.1.1 The collection has a publisher that can be associated"
                                @associating_coll_to_pub = true
                                params[:item][:collection_attributes] = {"name" => "", "about" => ""}
                            else
                                puts "17.1.2 the collection has no publisher"
                                flash[:alert] = "The item needs a publisher if it has a collection"
                                @error_raised = true
                            end
                        elsif @publisher_to_be_created 
                            puts "17.2 Collection unchanged and publisher to be created" 
                            if @collection.publisher.nil? 
                                puts "17.2.1 The collection has no publisher so the new one can be associated"
                                params[:item][:collection_attributes] = {"name" => "", "about" => ""}
                                @associating_coll_to_pub = true
                            else
                                puts "17.2.2 The collection has a publisher"
                                flash[:alert] = "The collection is associated to the previous publisher"
                                @error_raised = true
                            end
                        else
                            puts "17.3 Collection unchanged and an existing publisher has been filled in "
                            if !@collection.publisher.nil?
                                puts "17.3.1 The collection has a publisher"
                                if @collection.publisher.name != @publisher_attributes["name"]
                                    puts "17.3.1.1 The publisher names do not match"
                                    flash[:alert] =  "The collection is associated to the previous publisher"
                                    @error_raised = true
                                else
                                    puts "17.3.1.2 The publisher names do match"
                                    params[:item][:collection_attributes] = {"name" => "", "about" => ""}
                                end
                            else
                                puts "17.3.2 The collection has no publisher"
                            end
                        end
#                        flash[:alert] 
                        # 
                         
                     end
                  # else
                  #    puts "Collection not found"
                  end
               else
                  puts "18. The collection has no id, no collection was defined before the item was edited"
                  @newcollection = Collection.find_by_name(@collection_attributes["name"])
                  if @newcollection
                     puts "19. The new collection already exists"
                     if @no_publisher
                        if @newcollection.publisher.nil?
                           puts "19.3 No publisher and the chosen collection has no publisher"
                           flash[:alert] = "The collection must be associated to a publisher"
                            @error_raised = true
                        else
                           puts "19.4 No publisher but the chosen collection has a publisher"
                           params[:item][:collection_id] = @newcollection.id.to_s
                           params[:item][:collection_attributes] = {"name" => "", "about" => "", "id"=>""}
                           params[:item][:publisher_id] = @newcollection.publisher.id.to_s
                           params[:item][:publisher_attributes] = {"name" => "", "about" => "", "id"=>""}
                        end
                     elsif !@publisher_to_be_created
                        puts "19.1 The new publisher already exists"
                        if @newcollection.publisher.id.to_s == params[:item][:publisher_id]
                           puts "20. The publisher of the collection matches the filled_in publisher"
                           params[:item][:collection_id] = @newcollection.id.to_s
                           params[:item][:collection_attributes] = {"name" => "", "about" => ""}
                        else
                           puts "21. The publisher of the collection does not match the filled_in publisher"
                           flash[:alert] = "The collection already exists and is associated to another publisher"
                            @error_raised = true
                        end
                     else
                        puts "19.2 The new publisher has to be created"
                        if @newcollection.publisher.nil?
                           puts "19.2.1.The collection has no publisher => this should not have been allowed"
                           params[:item][:collection_id] = @newcollection.id.to_s
                           params[:item][:collection_attributes] = {"name" => "", "about" => ""}
                           @associating_coll_to_pub = true
                        else
                           puts "19.2.2.The collection has another publisher"
                           flash[:alert] = "The collection is already associated to an existing publisher"
                            @error_raised = true
                        end
                     end
                  else
                     puts "22. The new collection has to be created"
                     if @no_publisher
                        puts "22.3 No publisher so the new collection can't be associated to a publisher to be created"
                        flash[:alert] = "A new collection needs a publisher to be created"
                         @error_raised = true
                     elsif !@publisher_to_be_created
                        puts "22.1 The new publisher already exists"
                        params[:item][:collection_attributes]["publisher_id"] = params[:item][:publisher_id]
                     else
                        puts "22.2 The new publisher has to be created"
                        puts "the link between the collection and the publisher has to be made after the creation"
                        @associating_coll_to_pub = true
                     end
                     params[:item][:collection_id] = ""
                  end
               end
            else
               puts "Collection name empty"
            end
         end
      end


    if !@error_raised
       puts "To be sent params : #{params[:item]}"
      if @item.update(item_params)
         # Removing the collection if the publisher changes
         # if !item_params[:publisher_id].nil? && item_params[:publisher_id]!=@item.publisher_id
         #    if !@item.collection.nil?
         #       @item.collection.delete()
         #    end
         # end
         puts "Update OK"
         if @associating_coll_to_pub
            puts "Associating a new collection to a new publisher"
            if !@item.publisher.nil?
               @item.publisher.collections << @item.collection
            # else
            #    puts "No publisher for newly created item whereas an association between publisher and collection has been asked"
            end
         end
         redirect_to @item
      else
         puts @item.errors.messages.inspect
          @item.authors.build
          @item.illustrators.build
          @item.themes.build
          @item.categories.build
          if !params[:item][:publisher_attributes].nil?
              @item.build_publisher(:name => params[:item][:publisher_attributes]["name"], :about => params[:item][:publisher_attributes]["about"])
          else
              @item.build_publisher
          end
          if !params[:item][:collection_attributes].nil?
              @item.build_collection(:name => params[:item][:collection_attributes]["name"], :about => params[:item][:collection_attributes]["about"])
          else
              @item.build_collection
          end
         render 'edit'
      end
    else
#         error raised
        @item.authors.build
        @item.illustrators.build
        @item.themes.build
        @item.categories.build
        if !params[:item][:publisher_attributes].nil?
            @item.build_publisher(:name => params[:item][:publisher_attributes]["name"], :about => params[:item][:publisher_attributes]["about"])
        else
            @item.build_publisher
        end
        if !params[:item][:collection_attributes].nil?
            @item.build_collection(:name => params[:item][:collection_attributes]["name"], :about => params[:item][:collection_attributes]["about"])
        else
            @item.build_collection
        end
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
       params.require(:item).permit(:title, :cover, :publisher_id, :collection_id, :author_ids => [], :illustrator_ids => [], :theme_ids => [], :category_ids => [], authors_attributes: [:id, :firstname, :lastname, :about, :_destroy], illustrators_attributes: [:id, :firstname, :lastname, :about, :_destroy], themes_attributes: [:id, :name, :about, :_destroy], categories_attributes: [:id, :name, :about, :_destroy], publisher_attributes: [:id, :name, :about], collection_attributes: [:id, :name, :about, :publisher_id])
      #  params.require(:item).permit(:title, :publisher_id, :collection_id, :author_ids => [], :illustrator_ids => [], publisher_attributes: [:id, :name, :about])

   end




end
