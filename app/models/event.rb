class Event < ActiveRecord::Base
  validates_presence_of :name
  has_many :attendees
  belongs_to :category
  has_one :location
  has_many :event_groupships
  has_many :groups, :through => :event_groupships
  delegate :name, :to => :category, :prefix => true, :allow_nil => true
  accepts_nested_attributes_for :location, :allow_destroy => true, :reject_if => :all_blank
end
