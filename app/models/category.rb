class Category < ActiveRecord::Base
  validates_presence_of :name
  validates :name, uniqueness: { case_sensitive: false }
  validates :about, length: { maximum: 255 }
  has_and_belongs_to_many :items, inverse_of: :categories
end
