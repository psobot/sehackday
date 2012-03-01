class Contribution < ActiveRecord::Base
  belongs_to :participant
  belongs_to :project
  belongs_to :event
  belongs_to :tweet
end
