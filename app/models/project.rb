class Project < ActiveRecord::Base
  belongs_to :tweet
  has_many :contributions
  has_many :participants, :through => :contributions
  has_many :images

  alias :contributors :participants

end
