class Participant < ActiveRecord::Base
  belongs_to :tweet
  has_many :contributions
  has_many :projects, :through => :contributions
  has_many :attendances

  def has_url?
    !username.nil?
  end

  def url
    "http://twitter.com/#{self.username}"
  end
end
