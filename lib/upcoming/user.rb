module Upcoming
  class User
    include Upcoming::Defaults
    
    # Retrieve the details about a user.
    # 
    # +user_id+ (Required)
    # The user_id number of the user to look within. To run getInfo on multiple users, simply pass a comma-separated list of user_id numbers.
    # 
    def self.info(user_id)
      user_id = user_id.join(',') if user_id.is_a?(Array)
      Mash.new(self.get('/', :query => {:method => 'user.getInfo', :user_id => user_id}.merge(Upcoming.default_options))).rsp.user
    end
    
    # Retrieve the details about a user by username/screenname.
    # 
    # +username+ (Required)
    # The username (or screen name) of the user to look within. To run getInfoByUsername on multiple users, simply pass a comma-separated list of username strings.
    # 
    def self.info_by_username(username)
      username = username.join(',') if username.is_a?(Array)
      Mash.new(self.get('/', :query => {:method => 'user.getInfoByUsername', :username => username}.merge(Upcoming.default_options))).rsp.user
    end
    
    # Retrieve the details about a user by email
    # 
    # +email+ (Required)
    # The email of the user to look within. To run getInfoByEmail on multiple addresses, simply pass a comma-separated list of valid email addresses.
    # 
    def self.info_by_email(email)
      email = email.join(',') if email.is_a?(Array)
      Mash.new(self.get('/', :query => {:method => 'user.getInfoByEmail', :email => email}.merge(Upcoming.default_options))).rsp.user
    end
    
    # Retrieve a list of metros for a particular user.
    # 
    # +token+ (Required)
    # An authentication token.
    def self.metro_list(token)
      token = Upcoming::Auth.token_code(token)
      Mash.new(self.get('/', :query => {:method => 'user.getMetroList', :token => token}.merge(Upcoming.default_options))).rsp.metro
    end
    
    # Gets all events in the watchlist for a user. You may optionally pass authentication parameters for this function to get back private events from people who have authenticated user as a friend. The 'username' returned is the username of the watchlist owner. It also returns either status="attend" or status="watch". Watchlists for personal events that are created by friends of the user authenticated are shown.
    # 
    # In other words, you pass a username and password. Naturally, you'll have access to see any events created by others who have you as a friend. If the user_id you query has any of those specific personal events as an item in their watchlist, they will show up in this function.
    # 
    # Additionally, by default, user.getWatchlist only returns events with a start date >= today, or upcoming events. To get all events ever in a user's watchlist, or to get past events only, pass the "show" parameter.
    # 
    # +token+ (Optional)
    # An authentication token. 
    # 
    # +user_id+ (Required)
    # The user_id requested.
    # 
    # +show+ (Optional, Default: 'upcoming')
    # May be 'upcoming', 'all', or 'past' to retrieve corresponding events.
    #
    def self.watchlist(user_id, show='upcoming', token=nil)
      token = Upcoming::Auth.token_code(token)
      query = {:method => 'user.getWatchlist', :show => show}
      query.merge!(:token => token) if token
      Mash.new(self.get('/', :query => query.merge(Upcoming.default_options))).rsp.event
    end
    
    # Retrieve the events being watched/attended by a user's friends. These events can either be public or created by a person who calls the user a friend.
    # 
    # +token+ (Required)
    # An authentication token required to see the user's friends events. 
    # 
    # +per_page+ (Numeric, Optional, Default = 100)
    # Number of results to return per page. Max is 100 per page.
    # 
    # +page+ (Numeric, Optional, Default = 1)
    # The page number of results to return.
    def self.friends_events(token, per_page=100, page=1)
      token = Upcoming::Auth.token_code(token)
      query = {:method => 'user.getMyFriendsEvents', :per_page => per_page, :page => page}
      Mash.new(self.get('/', :query => query.merge(Upcoming.default_options))).rsp.event
    end
      
  end
end