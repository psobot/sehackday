class Contribution < ActiveRecord::Base
  belongs_to :participant
  belongs_to :project
  belongs_to :event
  belongs_to :tweet

  validates_uniqueness_of :participant_id, :scope => [:event_id, :project_id]
end
