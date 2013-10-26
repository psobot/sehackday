class Participant < ActiveRecord::Base
  belongs_to :tweet
  has_many :contributions
  has_many :projects, :through => :contributions, :uniq => true
  has_many :attendances

  validates_uniqueness_of :username

  def self.find_or_create_by_user_from_tweet u, t
    f = find_by_username(u['screen_name'])
    f ? f : create(:username => u['screen_name'],
                   :is_admin => false,
                   :full_name => u['name'],
                   :tweet_id => t.id)
  end

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
