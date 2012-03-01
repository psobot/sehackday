class Event < ActiveRecord::Base
  belongs_to :tweet

  belongs_to :location
  has_many :contributions
  has_many :projects, :through => :contributions
  has_many :attendances
  has_many :participants, :through => :attendances

  def is_in_the_future?
    Time.now < self.start
  end
end
