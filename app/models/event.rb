class Event < ActiveRecord::Base
  belongs_to :tweet

  belongs_to :location
  has_many :contributions
  has_many :projects, :through => :contributions
  has_many :attendances
  has_many :participants, :through => :attendances

  default_scope :order => 'created_at DESC'

  def is_in_the_future?
    Time.now < self.start
  end
end
