class Illustrator < ActiveRecord::Base
  validates_presence_of :firstname, :lastname
  validate :unique_name
  validates :about, length: { maximum: 255 }
  has_and_belongs_to_many :items, inverse_of: :illustrators

  def name
   [firstname, lastname].join " "
  end

  def unique_name
     matched_illustrator = Illustrator.where(['LOWER(firstname) = LOWER(?) AND LOWER(lastname) = LOWER(?)', self.firstname, self.lastname]).first
     errors.add(:base, 'Someone is already registered with that name') if matched_illustrator && (matched_illustrator.id != self.id)
  end

end
