class Collection < ActiveRecord::Base
   validates_presence_of :name
#   validates :name, uniqueness: { case_sensitive: false }
   validate :unique_name, :on => :create
   validates :about, length: { maximum: 255 }
   has_many :items, inverse_of: :collection
   belongs_to :publisher, inverse_of: :collections

   def to_s
      name
   end
    
    def unique_name
        matched_collection = Collection.where(['LOWER(name) = LOWER(?)', self.name]).first
        errors.add(:base, 'A collection is already registered with that name') if matched_collection && (matched_collection.id != self.id)
    end

end
