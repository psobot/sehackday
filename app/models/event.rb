class Event < ActiveRecord::Base
  belongs_to :tweet

  belongs_to :location
  has_many :projects, :through => :contributions
  has_many :participants, :through => :attendances
end
