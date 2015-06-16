class Group < ActiveRecord::Base
  has_many :event_groutships
  has_many :events, :through => :event_groupships
end
