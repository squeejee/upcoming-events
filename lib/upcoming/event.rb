module Upcoming
  class Event
    include Upcoming::Defaults
    
    # Retrieve event information and metadata for public and private events.
    #
    # +event_id+ (Required)
    # <em>The id number of the event. You can also pass multiple event_id's as an array or separated by commas to getInfo on multiple events.</em>
    # 
    # +token+ (Optional)
    # <em>An authentication token. Pass to see even private events.</em>
    # 
    def self.info(event_id, token=nil)
      token = token['token'] if token and token['token']
      event_id = event_id.join(',') if event_id.is_a?(Array)
      query = {:method => 'event.getInfo', :event_id => event_id}
      query.merge!(:token => token) unless token.blank?
      format :json
      Mash.new(self.get('/', :query => query.merge(Upcoming.default_options))).rsp.event
    end
    
    # Add a new event to the database. This method requires authentication.
    #
    # +token+ (Required)
    # <em>An authentication token. </em>
    # 
    # +name+ (Required)
    # <em>The name of the event.</em>
    # 
    # +venue_id+ (Numeric, Required)
    # <em>The venue_id of the event. To get a venue_id, try the venue.* series of functions.</em>
    # 
    # +category_id+ (Numeric, Required)
    # <em>The category_id of the event. To get a category_id, try the category.* series of functions.</em>
    # 
    # +start_date+ (YYYY-MM-DD, Required)
    # <em>The start date of the event, formatted as YYYY-MM-DD.</em>
    # 
    # +end_date+ (YYYY-MM-DD, Optional)
    # <em>The end date of the event, formatted as YYYY-MM-DD.</em>
    # 
    # +start_time+ (HH:MM:SS, Optional)
    # <em>The start time of the event, formatted as HH:MM:SS.</em>
    # 
    # +end_time+ (HH:MM:SS, Optional)
    # <em>The end time of the event, formatted as HH:MM:SS.</em>
    # 
    # +description+ (Optional)
    # <em>A textual description of the event.</em>
    # 
    # +url+ (Optional)
    # <em>The website URL for the event.</em>
    # 
    # +personal+ (1 or 0, Optional, Defaults to 0)
    # <em>A flag indicating whether the event should be public (0), or shown only to your friends (1).</em>
    # 
    # +selfpromotion+ (1 or 0, Optional, Defaults to 0)
    # <em>A flag indicating whether the event should be marked as a normal event (0), or as a self-promotional event (1).</em>
    # 
    # +ticket_url+ (Optional)
    # <em>The website URL for purchasing tickets to the event.</em>
    # 
    # +ticket_price+ (Optional)
    # <em>The price of a ticket to the event.</em>
    # 
    # +ticket_free+ (1 or 0, Optional, Defaults to 0)
    # <em>A flag indicating if the event is free (1) or not (0).</em>
    #   
    def self.add(info, token)
      token = Upcoming::Auth.token_code(token)
      format :xml
      body = {:method => 'event.add'}
      body.merge!({:token => token})
      body.merge!(info)
      body.merge!(Upcoming.default_options)
      body.merge!({:format => 'xml'})
      event = Mash.new(self.post('/', :body => body)).rsp.event
      self.info(event.id, token).first
    end
    
    # Edit an event in the database. Missing parameters will clear out their corresponding values in the event. You must authenticate as the user who added the event to do this. This method requires authentication.
    #
    # +token+ (Required)
    # An authentication token. 
    # 
    # +event_id+ (Required)
    # The id of the event to edit.
    # 
    # +name+ (Required)
    # The name of the event.
    # 
    # +venue_id+ (Numeric, Required)
    # The venue_id of the event. To get a venue_id, try the venue.* series of functions.
    # 
    # +category_id+ (Numeric, Required)
    # The category_id of the event. To get a category_id, try the category.* series of functions.
    # 
    # +start_date+ (YYYY-MM-DD, Required)
    # The start date of the event, formatted as YYYY-MM-DD.
    # 
    # +end_date+ (YYYY-MM-DD, Optional)
    # The end date of the event, formatted as YYYY-MM-DD.
    # 
    # +start_time+ (HH:MM:SS, Optional)
    # The start time of the event, formatted as HH:MM:SS.
    # 
    # +end_time+ (HH:MM:SS, Optional)
    # The end time of the event, formatted as HH:MM:SS.
    # 
    # +description+ (Optional)
    # A textual description of the event.
    # 
    # +url+ (Optional)
    # The website URL for the event.
    # 
    # +personal+ (1 or 0, Optional, Defaults to 0)
    # A flag indicating whether the event should be public (0), or shown only to your friends (1).
    # 
    # +selfpromotion+ (1 or 0, Optional, Defaults to 0)
    # A flag indicating whether the event should be marked as a normal event (0), or as a self-promotional event (1).
    # 
    # +ticket_url+ (Optional)
    # The website URL for purchasing tickets to the event.
    # 
    # +ticket_price+ (Optional)
    # The price of a ticket to the event.
    # 
    # +ticket_free+ (1 or 0, Optional, Defaults to 0)
    # A flag indicating if the event is free (1) or not (0).
    # 
    def self.edit(event, token)
      token = Upcoming::Auth.token_code(token)
      format :xml
      body = {:method => 'event.edit'}
      body.merge!({:token => token})
      body.merge!(event)
      body.merge!(Upcoming.default_options)
      body.merge!({:format => 'xml'})
      event = Mash.new(self.post('/', :body => body)).rsp.event
      self.info(event.id, token).first
    end
    
    # Add/Replace the user's current tags on an event. This method expects to receive a string with all the tags the user wishes to have on the object. It will replace the current set of user's tags on the event with the new list. This method requires authentication.
    #
    # +token+ (Required)
    # An authentication token. 
    # 
    # +event_id+ (Numeric, Required)
    # The event_id of the event. To get a event_id, try the event.search function.
    # 
    # +tags+ (String, Required)
    # A space-separated list of tags. Surround multi-word tags with quotes.
    # 
    # 
    def self.add_tags(event_id, token, tags)
      token = Upcoming::Auth.token_code(token)
      format :xml
      body = {:method => 'event.addTags'}
      body.merge!({:token => token})
      tag_list = tags.map{|t| "\"#{t}\""}.join(' ')
      body.merge!({:event_id => event_id, :tags => tag_list})
      body.merge!(Upcoming.default_options)
      body.merge!({:format => 'xml'})
      event = Mash.new(self.post('/', :body => body)).rsp.event
      self.info(event.id, token).first
    end
    
    # Remove a single tag from an event. This method requires authentication.
    #
    # 
    # +token+ (Required)
    # An authentication token. 
    # 
    # +event_id+ (Numeric, Required)
    # The event_id of the event. To get a event_id, try the event.search function.
    # 
    # +tag+ (String, Required)
    # A single "raw" tag to remove. A raw tag is the original string provided to tag the object with that also appear in the Event Detail page on Upcoming. These are not the normalized form used for searches, or returned via the API event.getInfo method. Note: This might mean that you need to keep track of tags added by users in your application.
    #
    def self.remove_tag(event_id, token, tag)
      token = Upcoming::Auth.token_code(token)
      format :xml
      body = {:method => 'event.removeTag'}
      body.merge!({:token => token})
      body.merge!({:event_id => event_id, :tag => tag})
      body.merge!(Upcoming.default_options)
      body.merge!({:format => 'xml'})
      event = Mash.new(self.post('/', :body => body)).rsp.event
      self.info(event.id, token).first
    end
    
    # Search Upcoming for public events by multiple facets. 
    # If optional authentication is provided, event.search also searches private events.
    # 
    # +search_text+ (Optional)
    # The search terms to be used to look for events. To collect all events with other filters applied, do not pass a search_text.
    # 
    # +location+ (Optional)
    # Only for use in proximity search within the US, the location parameter, if provided, will attempt to restrict search results to areas near that location. This may either be formatted as a comma-separated latitude and longitude (i.e. "37.821, -111.179"), or a fulltext location similar to the following:
    # 
    #     * City, State
    #     * City, State, Zip
    #     * Zip
    #     * Street, City, State
    #     * Street, City, State, Zip
    #     * Street, Zip
    # 
    # Any search that uses the location parameter will add the additional data elements "distance" and "distance_units" to the result set.
    # 
    # +radius+ (mi) (Optional, Default: 50mi., Max: 100mi.)
    # If location is specified, then event.search will look for a radius parameter. Otherwise, it will use 50mi. as the radius of the search.
    # 
    # +place_id+ (Optional)
    # An string ID like 'kH8dL0ubBZrvX_YZ', denoting a specific named geographical area. These can be seen in Upcoming 'place' URLs such as <http://upcoming.yahoo.com/place/kH8dLOubBZRvX_YZ>, denoting the city of San Francisco, California, USA.
    # Using a Place ID yields events from the exact boundaries of the place, and is not affected by the radius parameter. Eventually, Place IDs will replace the country_id, state_id, and metro_id parameters used below. However, those parameters are not deprecated yet.
    # 
    # +country_id+ (Numeric, Optional)
    # The country_id of the event, used to narrow down the responses. To get a country_id, try the metro.getCountryList function.
    # 
    # +state_id+ (Numeric, Optional)
    # The state_id of the event, used to narrow down the responses. To get a state_id, try the metro.getStateList function.
    # 
    # +metro_id+ (Numeric, Optional)
    # The metro_id of the event, used to narrow down the responses. To get a metro_id, try the metro.getList function.
    # 
    # +venue_id+ (Numeric, Optional)
    # A venue_id to search within. To get a venue_id, try the venue.* series of functions.
    # 
    # +woeid+ (Optional)
    # The WOEID of the place to which search results will be restricted.
    # 
    # +category_id+ (CSV Numeric, Optional)
    # A category_id integer or comma-separated list of category ids to search within. To get a category_id, try the category.getList function.
    # 
    # +min_date+ (YYYY-MM-DD, Optional)
    # Search all events after this date, formatted as YYYY-MM-DD.
    # 
    # +max_date+ (YYYY-MM-DD, Optional)
    # Search all events before this date, formatted as YYYY-MM-DD.
    # 
    # +tags+ (Optional)
    # A comma-separated list of tags. Events that have been tagged with any of the tags passed will be returned. 20 tags max.
    # 
    # +per_page+ (Numeric, Optional, Default = 100)
    # Number of results to return per page. Max is 100 per page.
    # 
    # +page+ (Numeric, Optional, Default = 1)
    # The page number of results to return.
    # 
    # +sort+ (String, Optional, Default = start-date-asc) The field and direction on which to sort the results. Distance sorts must ONLY be used if location is specified.
    # Meaningful values:
    # 
    #     * - distance-asc (Distance from provided location, ascending)
    #     * - name-asc (Event name, descending alphabetically)
    #     * - name-desc (Event name, ascending alphabetically)
    #     * - start-date-asc (Event's start date, in chronological order)
    #     * - start-date-desc (Event's start date, in reverse chronological order)
    #     * - posted-date-asc (The date the event was added to Upcoming, in chronological order)
    #     * - posted-date-desc (The date the event was added to Upcoming, in reverse chronological order)
    # 
    # 
    # 
    # +backfill+ (String, Optional)
    # If the first page of results returned has fewer than per_page results, try expanding the search.
    # Meaningful values:
    # 
    #     * - later (Remove any limits on maximum starting date)
    #     * - further (Double the existing search radius, up to 200 miles)
    # 
    # 
    # 
    # +variety+ (Boolean, Optional)
    # Attempt to provide more varied results. Currently, this is implemented as not showing more than one event of each category. This will greatly reduce the amount of results returned. This feature is intended for situations where you want to show a great diversity of results in a small space.
    # Meaningful values:
    # 
    #     * - 1 (that is, use parameter in URL as 'variety=1')
    # 
    # 
    # 
    # +rollup+ (String, Optional)
    # Used to display all future events of an event. By default only the last event of an event is displayed. This option provides the mechanism to override that behavior.
    # Meaningful values:
    # 
    #     * - none (Display all future events of an event)
    # 
    # 
    # 
    # +token+ (Optional)
    # An authentication token. 
    #
    def self.search(options={})
      Mash.new(self.get('/', :query => {:method => 'event.search'}.merge(options).merge(Upcoming.default_options))).rsp.event
    end
    
    # Get a watchlist for an event. You must pass authentication parameters for this function. 
    # You will only be shown your own private events plus those of people who have marked you as a friend. 
    # Returns user nodes for each user on the watchlist. Returns either status="attend" or status="watch"
    #
    # +token+ (Required)
    # An authentication token.
    # 
    # +event_id+ (Required)
    # The id of the event.
    #
    def self.watch_list(event_id, token)
      query = {:method => 'event.getWatchList', :token => token, :event_id => event_id }
      Mash.new(self.get('/', :query => query.merge(options).merge(Upcoming.default_options))).rsp.user
    end
    
    # For a given event_id, retrieve group information and metadata for 
    # public and private groups that include the event in their group calendar.
    #
    # +event_id+ (Required)
    # The id number of the event.
    # 
    # +token+ (Optional)
    # An authentication token. Pass to see even private groups.
    #
    def self.groups(event_id, token)
      query = {:method => 'event.getGroups', :token => token, :event_id => event_id }
      Mash.new(self.get('/', :query => query.merge(options).merge(Upcoming.default_options))).rsp.group
      
    end
    
    # Search Upcoming for featured or popular events in a specified place
    #
    # +location+ (Optional)
    # Only for use in proximity search within the US, the location parameter, if provided, will attempt to restrict search results to areas near that location. This may either be formatted as a comma-separated latitude and longitude (i.e. "37.821, -111.179"), or a fulltext location similar to the following:
    # 
    #     * City, State
    #     * City, State, Zip
    #     * Zip
    #     * Street, City, State
    #     * Street, City, State, Zip
    #     * Street, Zip
    # 
    # Any search that uses the location parameter will add the additional data elements "distance" and "distance_units" to the result set.
    # 
    # +radius+ (mi) (Optional, Default: 50mi., Max: 100mi.)
    # If location is specified, then event.search will look for a radius parameter. Otherwise, it will use 50mi. as the radius of the search.
    # 
    # +place_id+ (Optional)
    # An string ID like 'kH8dL0ubBZrvX_YZ', denoting a specific named geographical area. These can be seen in Upcoming 'place' URLs such as <http://upcoming.yahoo.com/place/kH8dLOubBZRvX_YZ>, denoting the city of San Francisco, California, USA.
    # Using a Place ID yields events from the exact boundaries of the place, and is not affected by the radius parameter. Eventually, Place IDs will replace the country_id, state_id, and metro_id parameters used below. However, those parameters are not deprecated yet.
    # 
    # +country_id+ (Numeric, Optional)
    # The country_id of the event, used to narrow down the responses. To get a country_id, try the metro.getCountryList function.
    # 
    # +state_id+ (Numeric, Optional)
    # The state_id of the event, used to narrow down the responses. To get a state_id, try the metro.getStateList function.
    # 
    # +metro_id+ (Numeric, Optional)
    # The metro_id of the event, used to narrow down the responses. To get a metro_id, try the metro.getList function.
    # 
    # +woeid+ (Optional)
    # The WOEID of the place to which search results will be restricted.
    # 
    # +per_page+ (Numeric, Optional, Default = 10)
    # Number of results to return per page. Max is 10 per page.
    # 
    # +sort+ (String, Optional) The field and direction on which to sort the results.
    # Meaningful values:
    # 
    #     * - score-asc (Relevance ascending)
    #     * - score-desc (Relevance descending)
    #
    # +filter+ (String, Optional, Default = popular)
    # Use this to filter the search results to get the best type of events in the given place.
    # Meaningful values:
    # 
    #     * - popular (Retrieve the events in my area that others in my area find interesting)
    #     * - featured (Retrieve the events in my area that look interesting)
    #   
    def self.best_in_place(query={})
      Mash.new(self.get('/', :query => {:method => 'event.getBestInPlace'}.merge(options).merge(Upcoming.default_options))).rsp.event
    end
  end
end