class AddPublisherToItems < ActiveRecord::Migration
  def change
    add_reference :items, :publisher, index: true
  end
end
