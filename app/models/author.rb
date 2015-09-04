class Author < ActiveRecord::Base

  validates_presence_of :firstname, :lastname
  validate :unique_name, :on => :create
  validates :about, length: { maximum: 255 }
  has_and_belongs_to_many :items, inverse_of: :authors

  def name
     [firstname, lastname].join " "
  end

  def unique_name
     matched_author = Author.where(['LOWER(firstname) = LOWER(?) AND LOWER(lastname) = LOWER(?)', self.firstname, self.lastname]).first
     errors.add(:base, 'Someone is already registered with that name') if matched_author && (matched_author.id != self.id)
  end

end
