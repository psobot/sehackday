class Attendance < ActiveRecord::Base
  belongs_to :participant
  belongs_to :event
  belongs_to :tweet
end

