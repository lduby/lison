class Author < ActiveRecord::Base
  validates_presence_of :firstname, :lastname
  validates :about, length: { maximum: 255 }
  has_and_belongs_to_many :items, inverse_of: :authors

  def name
   [firstname, lastname].join " "
  end

end
