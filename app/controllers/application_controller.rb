class ApplicationController < ActionController::Base

  def index
    render
  end

  def parse
    raise "Authentication key doesn't match!" if params[:key] != INCOMING_KEY
    Tweet.parse JSON.parse(params[:raw])
    render :json => {:status => 0, :message => "success"}
  end

end
