class Theme < ActiveRecord::Base
  validates_presence_of :name
  validates :about, length: { maximum: 255 }
  has_and_belongs_to_many :items, inverse_of: :themes
end
