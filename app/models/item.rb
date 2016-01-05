class Item < ActiveRecord::Base
  has_attached_file :cover, styles: { medium: "200x200>", thumb: "100x100>" }, default_url: "http://placehold.it/200x200"
  validates_attachment_content_type :cover, content_type: /\Aimage\/.*\Z/, size: { in: 0..20.kilobytes }
  validates_presence_of :title
#    validates :collections, :collections_name_uniqueness => true
  has_and_belongs_to_many :authors, inverse_of: :items
  has_and_belongs_to_many :illustrators, inverse_of: :items
  belongs_to :publisher, inverse_of: :items
  belongs_to :collection, inverse_of: :items
  has_and_belongs_to_many :themes, inverse_of: :items
  has_and_belongs_to_many :categories, inverse_of: :items
  accepts_nested_attributes_for :publisher,
                                 reject_if: proc { |attributes| attributes['name'].blank? }
  accepts_nested_attributes_for :collection,
                                 reject_if: proc { |attributes| attributes['name'].blank? }
  accepts_nested_attributes_for :authors,
                                 reject_if: proc { |attributes| attributes['lastname'].blank? || attributes['firstname'.blank?] },
                                 allow_destroy: true
  accepts_nested_attributes_for :illustrators,
                                 reject_if: proc { |attributes| attributes['lastname'].blank? || attributes['firstname'.blank?] },
                                 allow_destroy: true
  accepts_nested_attributes_for :themes,
                                 reject_if: proc { |attributes| attributes['name'].blank? },
                                 allow_destroy: true
  accepts_nested_attributes_for :categories,
                                 reject_if: proc { |attributes| attributes['name'].blank? },
                                 allow_destroy: true
                                     
                                     
  def authors_list
    self.authors.map{|a| a.name}.join(', ')
  end
                                     
  def illustrators_list
    self.illustrators.map{|i| i.name}.join(', ')
  end
                                     
  def themes_list
    self.themes.map{|t| t.name}.join(', ')
  end
                                     
  def categories_list
    self.categories.map{|c| c.name}.join(', ')
  end


end
