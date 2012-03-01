class Location < ActiveRecord::Base
  belongs_to :tweet
  has_many :events

  def full_name
    if address
      name + " (" + address + ")"
    else
      name
    end
  end

  def url
    if lat and lng
      "http://maps.google.com/maps?q=#{URI::encode(full_name)}&hl=en&ll=#{lat},#{lng}"
    else
      "http://www.google.com/search?q=#{URI::encode(full_name)}"
    end
  end

end

