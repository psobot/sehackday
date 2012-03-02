#!/usr/bin/env ruby
require "rubygems"
require "bundler/setup"
require 'tweetstream'
require 'logger'
require 'cgi'
require 'yajl'

USERNAME = 'sehackday'
@logger = Logger.new STDERR
ERROR_TIMEOUT = 160

settings_file = File.expand_path('../config/settings.yml', File.dirname(__FILE__))
settings = YAML::load(File.open(settings_file))

env = RUBY_PLATFORM.include?('darwin') ? 'development' : 'production'
HOST = settings[env]['host']
INCOMING_KEY = settings[env]['incoming_key']
TweetStream.configure do |config|
  config.consumer_key = settings['twitter']['consumer_key']
  config.consumer_secret = settings['twitter']['consumer_secret']
  config.oauth_token = settings['twitter']['oauth_token']
  config.oauth_token_secret = settings['twitter']['oauth_token_secret']
  config.auth_method = :oauth
  config.parser = :yajl
end

def send_to_api status
  @logger.info "Sending status..."
  # This should probably be going through the proper Ruby package, but it's a hack.
  `curl -d key=#{CGI.escape(INCOMING_KEY)} -d raw=#{CGI.escape(Yajl::Encoder.encode(status))} http://#{HOST}/tweet`
rescue Exception => ex
  @logger.error ex.message
  @logger.error ex.backtrace.join "\n"
end

client = TweetStream::Daemon.new('sehackday', :log_output => true)
client.on_error { |message| @logger.error message }
client.on_reconnect { |timeout, retries| @logger.error "Reconnect: timeout = #{timeout}, retries = #{retries}" }

# Start filtering based on location
begin
  @logger.info "Starting up the SEHackDay listener..."
  client.track("#sehackday") { |status| send_to_api status }
rescue HTTP::Parser::Error => ex
  # Although TweetStream should recover from
  # disconnections, it fails to do so properly.
  @logger.error "HTTP Parser error encountered - let's sleep for #{ERROR_TIMEOUT}s."
  @logger.error ex.message
  @logger.error ex.backtrace.join "\n"
  sleep ERROR_TIMEOUT
  retry
end
