class Tweet < ActiveRecord::Base

  def self.unprocessed
    self.where :processed => false
  end

end
