class Participant < ActiveRecord::Base
  belongs_to :tweet
  has_many :contributions
  has_many :attendances

  def url
    "http://twitter.com/#{self.username}"
  end
end
