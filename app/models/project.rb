class Project < ActiveRecord::Base
  belongs_to :tweet
  has_many :contributions
  has_many :participants, :through => :contributions, :uniq => true
  has_many :images

  alias :contributors :participants

  accepts_nested_attributes_for :images

  def self.find_by_name_or_links name, links
    p = find_by_name name
    return p if p
    links.each { |link|
      a = find_by_link link
      return a if a
    }
    nil
  end
end
