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
    tempfile << "  has_and_belongs_to_many :#{$related_model.downcase.pluralize(2)}, inverse_of: :#{$new_model_name.downcase.pluralize(2)}\n"
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
    tempfile2 << "  has_and_belongs_to_many :#{$new_model_name.downcase.pluralize(2)}, inverse_of: :#{$related_model.downcase.pluralize(2)}\n"
  end
end
f2.close
tempfile2.close

FileUtils.mv("file2.tmp", "app/models/#{$related_model.downcase}.rb")
puts "association added to app/models/#{$related_model.downcase}.rb"

# Association table

$habtm_table= $related_model.downcase < $new_model_name.downcase ? "#{$related_model.downcase.pluralize(2)}_#{$new_model_name.downcase.pluralize(2)}" : "#{$new_model_name.downcase.pluralize(2)}_#{$related_model.downcase.pluralize(2)}"
$migrate_file=%x[ls db/migrate/*create_#{$new_model_name.downcase.pluralize(2)}.rb].chomp

tempfile3=File.open("file3.tmp", 'w')
f3=File.new("#{$migrate_file}")
nextline=false
f3.each do |line|
  tempfile3<<line
  if nextline
    tempfile3 << "\n    create_table :#{$habtm_table.downcase}, id: false do |t|\n"
    if $related_model.downcase < $new_model_name
      tempfile3 << "      t.belongs_to :#{$related_model.downcase}\n"
      tempfile3 << "      t.belongs_to :#{$new_model_name.downcase}\n"
    else
      tempfile3 << "      t.belongs_to :#{$new_model_name.downcase}\n"
      tempfile3 << "      t.belongs_to :#{$related_model.downcase}\n"
    end
    tempfile3 << "    end\n"
    nextline=false
  end
  if line.downcase=~/t.timestamps/
    nextline=true
  end
end
f3.close
tempfile3.close

FileUtils.mv("file3.tmp", "#{$migrate_file}")
puts "Updated #{$migrate_file} with habtm table"

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
      rtfile<<"  resources :#{$new_model_name.downcase.pluralize(2)} do\n"
      rtfile<<"    resources :#{$related_model.downcase.pluralize(2)} do\n"
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
  FileUtils.cp("spec/models/#{$duplicated_model.downcase.pluralize(2)}_#{$related_model.downcase.pluralize(2)}_spec.rb","spec/models/#{$habtm_table}_spec.rb")
else
  FileUtils.cp("spec/models/#{$related_model.downcase.pluralize(2)}_#{$duplicated_model.downcase.pluralize(2)}_spec.rb","spec/models/#{$habtm_table}_spec.rb")
end
FileUtils.cp("spec/factories/#{$duplicated_model.downcase.pluralize(2)}.rb","spec/factories/#{$new_model_name.downcase.pluralize(2)}.rb")

model_file_names = ["spec/models/#{$new_model_name.downcase}_spec.rb", "spec/models/#{$habtm_table}_spec.rb", "spec/factories/#{$new_model_name.downcase.pluralize(2)}.rb"]

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
system("rails g controller #{$new_model_name.pluralize(2)}")

# controller duplication
FileUtils.cp("app/controllers/#{$duplicated_model.downcase.pluralize(2)}_controller.rb", "app/controllers/#{$new_model_name.downcase.pluralize(2)}_controller.rb")
FileUtils.cp("spec/controllers/#{$duplicated_model.downcase.pluralize(2)}_controller_spec.rb", "spec/controllers/#{$new_model_name.downcase.pluralize(2)}_controller_spec.rb")
controller_file_names = ["app/controllers/#{$new_model_name.downcase.pluralize(2)}_controller.rb", "spec/controllers/#{$new_model_name.downcase.pluralize(2)}_controller_spec.rb"]
controller_file_names.each do |file_name|
  text = File.read(file_name)
  replace_up_pl = text.gsub("#{$duplicated_model.pluralize(2)}", "#{$new_model_name.pluralize(2)}")
  replace_down_pl = replace_up_pl.gsub("#{$duplicated_model.downcase.pluralize(2)}", "#{$new_model_name.downcase.pluralize(2)}")
  replace_up = replace_down_pl.gsub("#{$duplicated_model}", "#{$new_model_name}")
  replace_down = replace_up.gsub("#{$duplicated_model.downcase}", "#{$new_model_name.downcase}")
  # To write changes to the file, use:
  File.open(file_name, "w") {|file| file.puts replace_down }
  puts "Created #{file_name}"
end

# Updating the controller of the related model
ctlfile=File.open("ctlfile.tmp", 'w')
controllerfile=File.new("app/controllers/#{$related_model.downcase.pluralize(2)}_controller.rb")
innewmethod=false
ineditmethod=false
controllerfile.each do |line|
  ctlfile<<line
  if innewmethod
    if line=~/.@#{$duplicated_model.downcase.pluralize(2)} = #{$duplicated_model}.all\n/
      ctlfile<<"    @#{$new_model_name.downcase.pluralize(2)} = #{$new_model_name}.all\n"
      innewmethod=false
    end
  end
  if ineditmethod
    if line=~/.@#{$duplicated_model.downcase.pluralize(2)} = #{$duplicated_model}.all\n/
      ctlfile<<"    @#{$new_model_name.downcase.pluralize(2)} = #{$new_model_name}.all\n"
      ineditmethod=false
    end
  end
  if line=~/^  def list\n/
    ctlfile<<"    if params[:#{$new_model_name.downcase}_id]\n"
    ctlfile<<"      @#{$new_model_name.downcase} = #{$new_model_name}.find(params[:#{$new_model_name.downcase}_id])\n"
    ctlfile<<"      @#{$related_model.downcase.pluralize(2)} = @#{$new_model_name.downcase}.#{$related_model.downcase.pluralize(2)}\n"
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
FileUtils.mv("ctlfile.tmp", "app/controllers/#{$related_model.downcase.pluralize(2)}_controller.rb")
ctlfile=File.open("ctlfile.tmp", 'w')
controllerfile=File.new("app/controllers/#{$related_model.downcase.pluralize(2)}_controller.rb")
controllerfile.each do |line|
  if line=~/^    params.require./
    new_line = line.chomp(")\n")
    new_line<<", :#{$new_model_name.downcase}_ids => [])\n"
    ctlfile<<new_line
  else
    ctlfile<<line
  end
end
controllerfile.close
ctlfile.close
FileUtils.mv("ctlfile.tmp", "app/controllers/#{$related_model.downcase.pluralize(2)}_controller.rb")
puts "Modified app/controllers/#{$related_model.downcase.pluralize(2)}_controller.rb"
puts "DO NOT FORGET to modify spec/controllers/#{$related_model.downcase.pluralize(2)}_controller_spec.rb"

# views duplication
FileUtils.mkdir_p("app/views/#{$new_model_name.downcase.pluralize(2)}") # _p because dir hierarchy already exists
FileUtils.cp("app/views/#{$duplicated_model.downcase.pluralize(2)}/index.html.erb", "app/views/#{$new_model_name.downcase.pluralize(2)}/index.html.erb")
FileUtils.cp("app/views/#{$duplicated_model.downcase.pluralize(2)}/show.html.erb", "app/views/#{$new_model_name.downcase.pluralize(2)}/show.html.erb")
FileUtils.cp("app/views/#{$duplicated_model.downcase.pluralize(2)}/_form.html.erb", "app/views/#{$new_model_name.downcase.pluralize(2)}/_form.html.erb")
FileUtils.cp("app/views/#{$duplicated_model.downcase.pluralize(2)}/new.html.erb", "app/views/#{$new_model_name.downcase.pluralize(2)}/new.html.erb")
FileUtils.cp("app/views/#{$duplicated_model.downcase.pluralize(2)}/edit.html.erb", "app/views/#{$new_model_name.downcase.pluralize(2)}/edit.html.erb")
#FileUtils.cp("app/views/#{$duplicated_model.downcase.pluralize(2)}/list.html.erb", "app/views/#{$new_model_name.downcase.pluralize(2)}/list.html.erb")
FileUtils.cp("spec/features/#{$duplicated_model.downcase.pluralize(2)}_spec.rb", "spec/features/#{$new_model_name.downcase.pluralize(2)}_spec.rb")

views_file_names = ["app/views/#{$new_model_name.downcase.pluralize(2)}/index.html.erb", "app/views/#{$new_model_name.downcase.pluralize(2)}/show.html.erb", "app/views/#{$new_model_name.downcase.pluralize(2)}/_form.html.erb", "app/views/#{$new_model_name.downcase.pluralize(2)}/new.html.erb", "app/views/#{$new_model_name.downcase.pluralize(2)}/edit.html.erb", "spec/features/#{$new_model_name.downcase.pluralize(2)}_spec.rb"]
views_file_names.each do |file_name|
  text = File.read(file_name)
  replace_up_pl = text.gsub("#{$duplicated_model.pluralize(2)}", "#{$new_model_name.pluralize(2)}")
  replace_down_pl = replace_up_pl.gsub("#{$duplicated_model.downcase.pluralize(2)}", "#{$new_model_name.downcase.pluralize(2)}")
  replace_up = replace_down_pl.gsub("#{$duplicated_model}", "#{$new_model_name}")
  replace_down = replace_up.gsub("#{$duplicated_model.downcase}", "#{$new_model_name.downcase}")
  # To write changes to the file, use:
  File.open(file_name, "w") {|file| file.puts replace_down }
  puts "Created #{file_name}"
end

puts "DO NOT FORGET to edit app/views/#{$related_model.downcase.pluralize(2)}/list.html.erb"
puts "DO NOT FORGET to edit app/views/#{$related_model.downcase.pluralize(2)}/show.html.erb"
puts "DO NOT FORGET to edit app/views/#{$related_model.downcase.pluralize(2)}/_form.html.erb"
puts "DO NOT FORGET to modify spec/features/#{$related_model.downcase.pluralize(2)}_spec.rb"
puts "DO NOT FORGET to edit your menu in app/views/layouts/application.html.erb"
