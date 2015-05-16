class CreateIllustrators < ActiveRecord::Migration
  def change
    create_table :illustrators do |t|
      t.string :firstname
      t.string :lastname
      t.text :about

      t.timestamps
    end

    create_table :illustrators_items, id: false do |t|
      t.belongs_to :illustrators
      t.belongs_to :items
    end
  end
end
