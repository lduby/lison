class AddPublisherToCollections < ActiveRecord::Migration
  def change
    add_reference :collections, :publisher, index: true
  end
end
