class Publisher < ActiveRecord::Base
  validates_presence_of :name
  validates :about, length: { maximum: 255 }
  has_many :items, inverse_of: :publisher
  has_many :collections, inverse_of: :publisher
  accepts_nested_attributes_for :collections,
                                reject_if: proc { |attributes| attributes['name'].blank? },
                                allow_destroy: true


  def to_s
     name
  end

end
