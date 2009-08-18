module Upcoming
  class Venue
    include Upcoming::Defaults
    
    # Retrieve the details about a venue.
    #
    # venue_id (Required)
    # The venue_id number of the venue to look within. To find venue_id's, use venue.getList. You can also pass multiple venue_id's separated by commas to getInfo on multiple venues.
    # 
    # token (Optional)
    # An authentication token. Optional for viewing private venues. 
    # 
    def self.info(venue_id, token=nil)
      venue_id = venue_id.join(',') if venue_id.is_a?(Array)
      token = token['token'] if token and token['token']
      query = {:method => 'venue.getInfo', :venue_id => venue_id}
      query.merge!({:token => token}) if token
      Mash.new(self.get('/', :query => query.merge(Upcoming.default_options))).rsp.venue
    end
    
    # Retrieve a list of venues for a particular metro.
    # 
    # metro_id (Required)
    # The metro_id number of the metro to look within. To find metro_id's, use metro.getList.
    # 
    # token (Optional)
    # An authentication token. Pass to return private venues.
    #
    def self.list(metro_id, token=nil)
      metro_id = metro_id.join(',') if metro_id.is_a?(Array)
      token = token['token'] if token and token['token']
      query = {:method => 'venue.getList', :metro_id => metro_id}
      query.merge!({:token => token}) if token
      Mash.new(self.get('/', :query => query.merge(Upcoming.default_options))).rsp.venue
    end
    
    # Allows searching through venues.
    # 
    # +search_text+ (Optional)
    # The search string to use when looking for venues. Supports quoted phrases and blank values for searching all venues. Please restrict by another parameter when using blank values.
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
    # +country_id+ (Numeric, Optional)
    # The country_id of the event, used to narrow down the responses. To get a country_id, try the metro.getCountryList function.
    # 
    # +state_id+ (Numeric, Optional)
    # The state_id of the event, used to narrow down the responses. To get a state_id, try the metro.getStateList function.
    # 
    # +metro_id+ (Numeric, Optional)
    # The metro_id of the event, used to narrow down the responses. To get a metro_id, try the metro.getList function.
    # 
    # +per_page+ (Numeric, Optional, Default = 100)
    # Number of results to return per page. Max is 100 per page.
    # 
    # +page+ (Numeric, Optional, Default = 1)
    # The page number of results to return.
    # 
    # +sort+ (One of name-desc, name-asc, distance-asc, distance-desc, Default = name-asc)
    # The field and direction on which to sort the results. Distance sorts must ONLY be used if location is specified.
    def self.search(options={})
      Mash.new(self.get('/', :query => {:method => 'venue.search'}.merge(options).merge(Upcoming.default_options))).rsp.venue
    end
    
    # Add a new venue to the database. You must pass authentication parameters for this function.
    # 
    # +token+ (Required)
    # An authentication token. 
    # 
    # +venuename+ (Required)
    # The name of the venue.
    # 
    # +venueaddress+ (Required)
    # The name of the venue.
    # 
    # +venuecity+ (Required)
    # The name of the venue.
    # 
    # +metro_id+ (Numeric,required if no location )
    # The metro_id of the venue. To get a metro_id, try the metro.* series of functions.
    # 
    # +location+ (Required if no metro_id)
    # Location parameter accepts comma separated address fields and adds the venue based on your input.
    # 
    # +venuezip+ (Optional)
    # The venue's Zip Code or equivalent.
    # 
    # +venuephone+ (Optional)
    # The venue's phone number.
    # 
    # +venueurl+ (Optional)
    # The url of the venue's website (if any).
    # 
    # +venuedescription+ (Optional)
    # A textual description of the venue.
    # 
    # +private+ (1 or 0, Optional, Defaults to 0)
    # A flag indicating whether the venue should be public (0), or shown only to your friends (1).
    #
    def self.add(info, token)
      token = Upcoming::Auth.token_code(token)
      format :xml
      body = {:method => 'venue.add'}
      body.merge!({:token => token})
      body.merge!(info)
      body.merge!(Upcoming.default_options)
      body.merge!({:format => 'xml'})
      Mash.new(self.post('/', :body => body)).rsp.venue
    end
    
    # Edit a venue. Only the authenticated user that added the venue may edit it. You must pass authentication parameters for this function.
    # 
    # +token+ (Required)
    # An authentication token. 
    # 
    # +venue_id+ (Numeric, Required)
    # The id of the venue.
    # 
    # +venuename+ (Required)
    # The name of the venue.
    # 
    # +venueaddress+ (Required)
    # The name of the venue.
    # 
    # +venuecity+ (Required)
    # The name of the venue.
    # 
    # +metro_id+ (Numeric, Required)
    # The metro_id of the venue. To get a metro_id, try the metro.* series of functions.
    # 
    # +venuezip+ (Optional)
    # The venue's Zip Code or equivalent.
    # 
    # +venuephone+ (Optional)
    # The venue's phone number.
    # 
    # +venueurl+ (Optional)
    # The url of the venue's website (if any).
    # 
    # +venuedescription+ (Optional)
    # A textual description of the venue.
    # 
    # +private+ (1 or 0, Optional, Defaults to 0)
    # A flag indicating whether the venue should be public (0), or shown only to your friends (1).
    #
    def self.edit(venue, token)
      token = Upcoming::Auth.token_code(token)
      format :xml
      body = {:method => 'venue.edit'}
      body.merge!({:token => token})
      body.merge!(event)
      body.merge!(Upcoming.default_options)
      body.merge!({:format => 'xml'})
      Mash.new(self.post('/', :body => body)).rsp.venue
    end
  end
end