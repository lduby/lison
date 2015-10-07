#!/usr/bin/env ruby
require File.expand_path('../config/environment',  __FILE__)
require 'fileutils'

# asking info
puts "New model name ?"
$new_model_name=gets.chomp
# $new_model_name="Illustrator"
puts "Related model ?"
$related_model=gets.chomp
# $related_model="Item"
puts "Which model to duplicate ?"
$duplicated_model=gets.chomp

# creating the model
$duplicated_class = Object.const_get($duplicated_model)
$duplicated_attributes=$duplicated_class.columns.collect { |c| "#{c.name}:#{c.type}" }
i=0
$new_model_attributes=""
$duplicated_attributes.each do |att|
  i += 1
  if i>1 && i<$duplicated_attributes.size-1
    $new_model_attributes<<att<<" "
  end
end
$new_model_attributes.chop
puts "Generating model #{$new_model_name} with attributes #{$new_model_attributes}"
system ("rails g model #{$new_model_name} #{$new_model_attributes}")

# adding validation
$attributes = $new_model_attributes.split(' ')
$validation_attributes = ""
$is_mandatory = false
$attributes.each do |attribute|
  puts "Is #{attribute} mandatory ? [y/n]"
  $answer = gets.chomp
  $answer == "y" ? $is_mandatory=true : $is_mandatory= false
  if $is_mandatory
    attribute_properties = attribute.split(":")
    $validation_attributes << ":#{attribute_properties[0]}, "
    $is_mandatory = false
  end
end

tmpfile=File.open("modelfile.tmp", 'w')
ff=File.new("app/models/#{$new_model_name.downcase}.rb")
ff.each do |line|
  tmpfile<<line
  if line=~/.ActiveRecord::Base/
    tmpfile << "  validates_presence_of #{$validation_attributes.chomp(", ")}\n"
  end
end
ff.close
tmpfile.close
FileUtils.mv("modelfile.tmp", "app/models/#{$new_model_name.downcase}.rb")
puts "Validation added to app/models/#{$new_model_name.downcase}.rb"

# adding the habtm relationship to models
tempfile=File.open("file.tmp", 'w')
f=File.new("app/models/#{$new_model_name.downcase}.rb")
f.each do |line|
  tempfile<<line
  if line.downcase=~/validates_presence_of./
    tempfile << "  has_many :#{$related_model.downcase}s\n"
  end
end
f.close
tempfile.close
FileUtils.mv("file.tmp", "app/models/#{$new_model_name.downcase}.rb")
puts "association added to app/models/#{$new_model_name.downcase}.rb"

tempfile2=File.open("file2.tmp", 'w')
f2=File.new("app/models/#{$related_model.downcase}.rb")
f2.each do |line|
  tempfile2<<line
  if line.downcase=~/validates_presence_of./
    tempfile2 << "  belongs_to :#{$new_model_name.downcase}\n"
    tempfile2 << "  accepts_nested_attributes_for :#{$new_model_name.downcase}\n"
  end
end
f2.close
tempfile2.close

FileUtils.mv("file2.tmp", "app/models/#{$related_model.downcase}.rb")
puts "association added to app/models/#{$related_model.downcase}.rb"

# Adding foreign key in the related model
system("rails g migration Add#{$new_model_name}To#{$related_model}s #{$new_model_name.downcase}:references")
$migrate_file=%x[ls db/migrate/*add_#{$new_model_name.downcase}_to_#{$related_model.downcase}s.rb].chomp
puts "Created #{$migrate_file} for association foreign_key"

# Do the migration
puts "Running the migration"
system("rake db:migrate")

# Adding routes
rtfile=File.open("routefile.tmp", 'w')
routesfile=File.new("config/routes.rb")
inparagraph=false
routesfile.each do |line|
  rtfile<<line
  if inparagraph
    if line=~/.end/
      rtfile<<"  resources :#{$new_model_name.downcase}s do\n"
      rtfile<<"    resources :#{$related_model.downcase}s do\n"
      rtfile<<"      get :list, :on => :collection, :as => :list\n"
      rtfile<<"    end\n"
      rtfile<<"  end\n"
      inparagraph=false
    end
  end
  if line=~/Example resource route with sub-resources:/
    inparagraph=true
  end
end
routesfile.close
rtfile.close
FileUtils.mv("routefile.tmp", "config/routes.rb")
puts "Modified config/routes.rb"

# Existing model duplication


# model duplication

FileUtils.cp("spec/models/#{$duplicated_model.downcase}_spec.rb","spec/models/#{$new_model_name.downcase}_spec.rb")
if $duplicated_model < $related_model
  FileUtils.cp("spec/models/#{$duplicated_model.downcase}s_#{$related_model.downcase}s_spec.rb","spec/models/#{$habtm_table}_spec.rb")
else
  FileUtils.cp("spec/models/#{$related_model.downcase}s_#{$duplicated_model.downcase}s_spec.rb","spec/models/#{$habtm_table}_spec.rb")
end
FileUtils.cp("spec/factories/#{$duplicated_model.downcase}s.rb","spec/factories/#{$new_model_name.downcase}s.rb")

model_file_names = ["spec/models/#{$new_model_name.downcase}_spec.rb", "spec/models/#{$habtm_table}_spec.rb", "spec/factories/#{$new_model_name.downcase}s.rb"]

model_file_names.each do |file_name|
  text = File.read(file_name)
  replace_up = text.gsub("#{$duplicated_model}", "#{$new_model_name}")
  replace_down = replace_up.gsub("#{$duplicated_model.downcase}", "#{$new_model_name.downcase}")
  # To write changes to the file, use:
  File.open(file_name, "w") {|file| file.puts replace_down }
  puts "Created #{file_name}"
end

puts "DO NOT FORGET to add required methods in app/model/#{$new_model_name.downcase}.rb, they are not duplicated"

# Generating controller
puts "Generating controller"
system("rails g controller #{$new_model_name}s")

# controller duplication
FileUtils.cp("app/controllers/#{$duplicated_model.downcase}s_controller.rb", "app/controllers/#{$new_model_name.downcase}s_controller.rb")
FileUtils.cp("spec/controllers/#{$duplicated_model.downcase}s_controller_spec.rb", "spec/controllers/#{$new_model_name.downcase}s_controller_spec.rb")
controller_file_names = ["app/controllers/#{$new_model_name.downcase}s_controller.rb", "spec/controllers/#{$new_model_name.downcase}s_controller_spec.rb"]
controller_file_names.each do |file_name|
  text = File.read(file_name)
  replace_up = text.gsub("#{$duplicated_model}", "#{$new_model_name}")
  replace_down = replace_up.gsub("#{$duplicated_model.downcase}", "#{$new_model_name.downcase}")
  # To write changes to the file, use:
  File.open(file_name, "w") {|file| file.puts replace_down }
  puts "Created #{file_name}"
end

# Updating the controller of the related model
ctlfile=File.open("ctlfile.tmp", 'w')
controllerfile=File.new("app/controllers/#{$related_model.downcase}s_controller.rb")
innewmethod=false
ineditmethod=false
controllerfile.each do |line|
  ctlfile<<line
  if innewmethod
    if line=~/.@#{$duplicated_model.downcase}s = #{$duplicated_model}.all\n/
      ctlfile<<"    @#{$new_model_name.downcase}s = #{$new_model_name}.all\n"
      innewmethod=false
    end
  end
  if ineditmethod
    if line=~/.@#{$duplicated_model.downcase}s = #{$duplicated_model}.all\n/
      ctlfile<<"    @#{$new_model_name.downcase}s = #{$new_model_name}.all\n"
      ineditmethod=false
    end
  end
  if line=~/^  def list\n/
    ctlfile<<"    if params[:#{$new_model_name.downcase}_id]\n"
    ctlfile<<"      @#{$new_model_name.downcase} = #{$new_model_name}.find(params[:#{$new_model_name.downcase}_id])\n"
    ctlfile<<"      @#{$related_model.downcase}s = @#{$new_model_name.downcase}.#{$related_model.downcase}s\n"
    ctlfile<<"    end\n"
  end
  if line=~/^  def new\n/
    innewmethod=true
  end
  if line=~/^  def edit\n/
    ineditmethod=true
  end
end
controllerfile.close
ctlfile.close
FileUtils.mv("ctlfile.tmp", "app/controllers/#{$related_model.downcase}s_controller.rb")
ctlfile=File.open("ctlfile.tmp", 'w')
controllerfile=File.new("app/controllers/#{$related_model.downcase}s_controller.rb")
controllerfile.each do |line|
  if line=~/^    params.require./
    new_line = line.chomp(")\n")
    new_line<<", :#{$new_model_name.downcase}_id)\n"
    ctlfile<<new_line
  else
    ctlfile<<line
  end
end
controllerfile.close
ctlfile.close
FileUtils.mv("ctlfile.tmp", "app/controllers/#{$related_model.downcase}s_controller.rb")
puts "Modified app/controllers/#{$related_model.downcase}s_controller.rb"

puts "DO NOT FORGET to modify spec/controllers/#{$related_model.downcase}s_controller_spec.rb"

# views duplication
FileUtils.mkdir_p("app/views/#{$new_model_name.downcase}s") # _p because dir hierarchy already exists
FileUtils.cp("app/views/#{$duplicated_model.downcase}s/index.html.erb", "app/views/#{$new_model_name.downcase}s/index.html.erb")
FileUtils.cp("app/views/#{$duplicated_model.downcase}s/show.html.erb", "app/views/#{$new_model_name.downcase}s/show.html.erb")
FileUtils.cp("app/views/#{$duplicated_model.downcase}s/_form.html.erb", "app/views/#{$new_model_name.downcase}s/_form.html.erb")
FileUtils.cp("app/views/#{$duplicated_model.downcase}s/new.html.erb", "app/views/#{$new_model_name.downcase}s/new.html.erb")
FileUtils.cp("app/views/#{$duplicated_model.downcase}s/edit.html.erb", "app/views/#{$new_model_name.downcase}s/edit.html.erb")
#FileUtils.cp("app/views/#{$duplicated_model.downcase}s/list.html.erb", "app/views/#{$new_model_name.downcase}s/list.html.erb")
FileUtils.cp("spec/features/#{$duplicated_model.downcase}s_spec.rb", "spec/features/#{$new_model_name.downcase}s_spec.rb")

views_file_names = ["app/views/#{$new_model_name.downcase}s/index.html.erb", "app/views/#{$new_model_name.downcase}s/show.html.erb", "app/views/#{$new_model_name.downcase}s/_form.html.erb", "app/views/#{$new_model_name.downcase}s/new.html.erb", "app/views/#{$new_model_name.downcase}s/edit.html.erb", "spec/features/#{$new_model_name.downcase}s_spec.rb"]
views_file_names.each do |file_name|
  text = File.read(file_name)
  replace_up = text.gsub("#{$duplicated_model}", "#{$new_model_name}")
  replace_down = replace_up.gsub("#{$duplicated_model.downcase}", "#{$new_model_name.downcase}")
  # To write changes to the file, use:
  File.open(file_name, "w") {|file| file.puts replace_down }
  puts "Created #{file_name}"
end

# Menu update

menufile=File.open("menufile.tmp", 'w')
layoutfile=File.new("app/views/layouts/application.html.erb")
layoutfile.each do |line|
  if line=~/^    <p>Menu./
    new_line = line.chomp("</p>")
    new_line<<" | <%= link_to \"#{$new_model_name}s\", controller: \"#{$new_model_name.downcase}s\" %></p>\n"
    menufile<<new_line
  else
    menufile<<line
  end
end
layoutfile.close
menufile.close
FileUtils.mv("menufile.tmp", "app/views/layouts/application.html.erb")
puts "Modified app/views/layouts/application.html.erb"

# Recommandations

puts "DO NOT FORGET to edit app/views/#{$related_model.downcase}s/list.html.erb with the following code: "
puts "<% if !@#{$new_model_name.downcase}.nil ? %>"
puts "  <h1><%= @#{$new_model_name.downcase}.<main_attribute> %> #{$related_model.downcase}s</h1>"
puts "<% end %>"
puts "DO NOT FORGET to edit app/views/#{$related_model.downcase}s/show.html.erb with the following code: "
puts "<p id=#{$related_model.downcase}_#{$new_model_name.downcase}><strong>#{$new_model_name}: </strong>"
puts " <% if @#{$related_model.downcase}.#{$new_model_name.downcase} %>"
puts " <%=link_to @#{$related_model.downcase}.#{$new_model_name.downcase}.<main_attribute>, #{$new_model_name.downcase}_path(@#{$related_model}.#{$new_model_name.downcase}), id: \"show_#{$new_model_name.downcase}_\#\{@#{$related_model.downcase}.#{$new_model_name}.id\}\" %>"
puts " <% end %>"
puts "</p>"
puts "DO NOT FORGET to edit app/views/#{$related_model.downcase}s/_form.html.erb with the following code:"
puts "  <p>"
puts "    <b>#{$new_model_name}</b> (<%= link_to 'New', new_#{$new_model_name.downcase}_path %>)<br />"
puts "    <div class=\"field\">"
puts "      <%= collection_select(:#{$related_model.downcase}, :#{$new_model_name.downcase}_id, @#{$new_model_name.downcase}s, :id, :<attribute to display in select box>) %>"
puts "    </div>"
puts "  </p>"
puts "DO NOT FORGET to modify spec/features/#{$related_model.downcase}s_spec.rb"
