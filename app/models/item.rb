class Item < ActiveRecord::Base
  validates_presence_of :title
  has_and_belongs_to_many :authors, inverse_of: :items
  has_and_belongs_to_many :illustrators, inverse_of: :items
  belongs_to :publisher, inverse_of: :items
  belongs_to :collection, inverse_of: :items
  accepts_nested_attributes_for :publisher
  accepts_nested_attributes_for :collection

end
