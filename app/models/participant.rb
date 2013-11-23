class Participant < ActiveRecord::Base
  has_many :contributions
  has_many :projects, :through => :contributions, :uniq => true
  has_many :attendances

  def has_url?
    !username.nil?
  end

  def url
    "http://twitter.com/#{self.username}"
  end

  def display_name
    if full_name.nil?
      "@" + username
    else
      full_name
    end
  end
end
