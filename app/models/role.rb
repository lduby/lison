class Role < ActiveRecord::Base
  validates :description, length: { maximum: 255 }
  has_and_belongs_to_many :users
end
