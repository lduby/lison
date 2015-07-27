class CreateThemes < ActiveRecord::Migration
  def change
    create_table :themes do |t|
      t.string :name
      t.text :about
      t.datetime :created_at

      t.timestamps
    end

    create_table :items_themes, id: false do |t|
      t.belongs_to :item
      t.belongs_to :theme
    end
  end
end
