class Location < ActiveRecord::Base
  belongs_to :tweet
  has_many :events
end

