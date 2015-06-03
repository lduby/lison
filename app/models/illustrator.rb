class Illustrator < ActiveRecord::Base
  validates_presence_of :firstname, :lastname
  has_and_belongs_to_many :items, inverse_of: :illustrators

  def name
   [firstname, lastname].join " "
  end

end
