class Collection < ActiveRecord::Base
   validates_presence_of :name
   validates :about, length: { maximum: 255 }
   has_many :items, inverse_of: :collection
   belongs_to :publisher, inverse_of: :collections

   def to_s
      name
   end

end
