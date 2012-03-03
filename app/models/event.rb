class Event < ActiveRecord::Base
  belongs_to :tweet

  belongs_to :location
  has_many :contributions
  has_many :projects, :through => :contributions, :uniq => true
  has_many :attendances
  has_many :participants, :through => :attendances

  default_scope :order => 'created_at DESC'

  def self.at time
    where("? BETWEEN start AND finish", time.utc).first
  end

  def is_happening_now?
    Time.now > self.start && Time.now < self.finish
  end

  def is_in_the_future?
    Time.now < self.start
  end
end
