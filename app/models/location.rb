class Location < ActiveRecord::Base
  has_many :events

  def url
    if lat and lng
      "http://maps.google.com/maps?q=#{URI::encode(address)}&hl=en&ll=#{lat},#{lng}"
    elsif address
      "http://maps.google.com/maps?q=#{URI::encode(address)}&hl=en"
    else
      "http://www.google.com/search?q=#{URI::encode(name + " " + address)}"
    end
  end

end

