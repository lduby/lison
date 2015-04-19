class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :firstname
      t.string :lastname
      t.text :about

      t.timestamps
    end

    create_table :authors_items, id: false do |t|
      t.belongs_to :author
      t.belongs_to :item
    end
  end
end
