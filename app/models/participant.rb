class Participant < ActiveRecord::Base
  belongs_to :tweet
  has_many :contributions
  has_many :attendances
end
