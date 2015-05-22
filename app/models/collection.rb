class Collection < ActiveRecord::Base
  validates_presence_of :name
  has_many :items
  belongs_to :publisher
  accepts_nested_attributes_for :publisher
end
