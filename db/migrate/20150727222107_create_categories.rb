class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.text :about

      t.timestamps
    end

    create_table :categories_items, id: false do |t|
      t.belongs_to :category
      t.belongs_to :item
    end
  end
end
