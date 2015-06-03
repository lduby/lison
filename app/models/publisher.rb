class Publisher < ActiveRecord::Base
  validates_presence_of :name
  has_many :items, inverse_of: :publisher
  has_many :collections, inverse_of: :publisher
end
