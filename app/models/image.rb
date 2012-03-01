require 'open-uri'
class Image < ActiveRecord::Base
  belongs_to :project
  belongs_to :event
  has_attached_file :file, :styles => { :thumb => "100x100>" }

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
      a = meta["content-disposition"].match(/filename=(.+[^;])/)
      if a
        a[1]
      else
        base_uri.path.split('/').last
      end
    end
    
    io.original_filename.blank? ? nil : io
  end
end
