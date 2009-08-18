module Upcoming
  class Watchlist
    include Upcoming::Defaults
    
    # Retrieve the watchlist for a user.
    # 
    # +token+ (Required)
    # An authentication token. 
    # 
    # +min_date+ (YYYY-MM-DD, Optional)
    # Get watchlisted events on or after this date, formatted as YYYY-MM-DD.
    # 
    # +max_date+ (YYYY-MM-DD, Optional)
    # Get watchlisted events on or before this date, formatted as YYYY-MM-DD.
    # 
    # +sort+ ('start-date-asc', 'start-date-desc', 'post-date-asc', 'post-date-desc') [Default: 'post-date-asc']
    # Sort the watchlisted events by start date or post date.
    #
    def self.list(token, query={})
      query.merge!({:method => 'watchlist.getList'})
      Mash.new(self.get('/', :query => query.merge(Upcoming.default_options))).rsp.watchlist
    end
    
    # Add an event to a user's watchlist. This function will delete an existing watchlist setting and replace it with the new one, so you don't have to call watchlist.remove first.
    # 
    # +token+ (Required)
    # An authentication token. 
    # 
    # +event_id+ (Numeric, Required)
    # The event_id of the event. To get a event_id, try the event.search function.
    # 
    # +status+ (Either 'attend' or 'watch', Optional, Default = 'watch')
    # A setting indicating whether you plan to attend or watch this event.
    #
    def self.add(token, event_id, status='watch')
      token = Upcoming::Auth.token_code(token)
      format :xml
      body = {:method => 'watchlist.add', :token => token, :event_id => event_id, :status => status}
      body.merge!(Upcoming.default_options)
      body.merge!({:format => 'xml'})
      Mash.new(self.post('/', :body => body)).rsp.watchlist
    end
    
    # Remove a watchlist record from a user's watchlist.
    # 
    # +token+ (Required)
    # An authentication token. 
    # 
    # +watchlist_id+ (Numeric, Required)
    # The watchlist_id of the event. To get a watchlist_id, try the watchlist.getList function.
    #
    def self.remove(token, watchlist_id)
      token = Upcoming::Auth.token_code(token)
      format :xml
      body = {:method => 'watchlist.remove', :token => token, :watchlist_id => watchlist_id}
      body.merge!(Upcoming.default_options)
      body.merge!({:format => 'xml'})
      Mash.new(self.post('/', :body => body)).rsp.stat == 'ok'
    end
  end
end