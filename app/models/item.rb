class Item < ActiveRecord::Base
  validates_presence_of :title
  has_and_belongs_to_many :authors
  has_and_belongs_to_many :illustrators
  belongs_to :publisher
  accepts_nested_attributes_for :publisher

end
