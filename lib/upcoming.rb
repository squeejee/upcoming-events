require 'rubygems'

gem 'mash', '~> 0.0.3'
require 'mash'

gem 'httparty', '~> 0.4.3'
require 'httparty'

module Upcoming
  class APIKeyNotSet   < StandardError; end
  module Defaults
    def self.included(base)
      base.send :include, HTTParty
      base.send(:base_uri, 'upcoming.yahooapis.com/services/rest')
      base.send(:format, :json)
    end
  end
  
  def self.api_key=(value)
    @api_key = value
  end
  
  def self.api_key
    @api_key
  end
  
  def self.default_options
    raise Upcoming::APIKeyNotSet.new("Please get your API key from http://upcoming.yahoo.com/services/api/keygen.php") if self.api_key.blank?
    {:api_key => self.api_key, :format => 'json'}
  end
end

directory = File.expand_path(File.dirname(__FILE__))
require File.join(directory, 'upcoming', 'auth')
require File.join(directory, 'upcoming', 'user')
require File.join(directory, 'upcoming', 'group')
require File.join(directory, 'upcoming', 'metro')
require File.join(directory, 'upcoming', 'event')
require File.join(directory, 'upcoming', 'category')
require File.join(directory, 'upcoming', 'country')
require File.join(directory, 'upcoming', 'venue')
require File.join(directory, 'upcoming', 'watchlist')
require File.join(directory, 'upcoming', 'state')
