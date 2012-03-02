require 'open-uri'
class Image < ActiveRecord::Base

  belongs_to :project
  belongs_to :event
  has_attached_file :file, :styles => { :thumb => "100x100>" }

  AVAILABLE_HOSTS = %w{
    twitpic.com
  }

  def self.download url
    a = Image.new
    #TODO: Translate URL into exact photo URL here
    if AVAILABLE_HOSTS.any? {|s| url.include? s}
      raise NotImplementedError
      url = "blah"
    end
    a.file_from_url url
    a
  end

  def file_from_url(url)
    self.file = download_remote_file(url)
  end

  private
  
  def download_remote_file(url)
    io = open(url)
    
    # overrides Paperclip::Upfile#original_filename;
    # we are creating a singleton method on specific object ('io')
    def io.original_filename
      # OpenURI::Meta's meta attribute returns a hash of headers
      a = meta["content-disposition"].match(/filename=(.+[^;])/)[1]
    rescue NoMethodError
      base_uri.path.split('/').last.split(':').first
    end
    
    io.original_filename.blank? ? nil : io
  end
end
