class Item < ActiveRecord::Base
  validates_presence_of :title
  has_and_belongs_to_many :authors, inverse_of: :items
  has_and_belongs_to_many :illustrators, inverse_of: :items
  belongs_to :publisher, inverse_of: :items
  belongs_to :collection, inverse_of: :items
  has_and_belongs_to_many :themes, inverse_of: :items
  has_and_belongs_to_many :categories, inverse_of: :items
  accepts_nested_attributes_for :publisher,
                                 reject_if: proc { |attributes| attributes['name'].blank? }
  accepts_nested_attributes_for :collection
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


end
