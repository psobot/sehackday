class Project < ActiveRecord::Base
  belongs_to :tweet
  has_many :participants, :through => :contributions
end
