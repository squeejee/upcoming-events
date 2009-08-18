module Upcoming
  class Metro
    include Upcoming::Defaults
    
    # Retrieve the details about a metro.
    # 
    # +metro_id+ (Required)
    # The metro_id number of the metro to look within. To find metro_id's, use metro.getList. To run getInfo on multiple metros, simply pass a comma-separated list of metro_id numbers.
    #
    def self.info(metro_id)
      metro_id = metro_id.join(',') if metro_id.is_a?(Array)
      Mash.new(self.get('/', :query => {:method => 'metro.getInfo', :metro_id => metro_id}.merge(Upcoming.default_options))).rsp.metro
    end
    
    # Retrieve the single record of the most popular metro in the area of a latitude and longitude coordinate. Will return a 404 Not Found if one cannot be found. Only the US and some of Canada is currently supported. To get a Lat/Lon from a street address, try Yahoo!'s Geocoding API. Useful for adding new venues.
    # 
    # +latitude+ (Float, Required)
    # Latitude coordinate.
    # 
    # +longitude+ (Float, Required)
    # Longitude coordinate.
    #
    def self.for_latitude_and_longitude(latitude, longitude)
      Mash.new(self.get('/', :query => {:method => 'metro.getForLatLon', :latitude => latitude, :longitude => longitude}.merge(Upcoming.default_options))).rsp.metro
    end
    
    # Searches for metros whose name or "code" matches the search_text.
    #
    # +search_text+ (Optional)
    # The search text to use. Supports quoted strings and empty parameter (to display all). Please restrict by another parameter when using blank values.
    # 
    # +country_id+ (Numeric, Optional)
    # The country_id of the event, used to narrow down the responses. To get a country_id, try the metro.getCountryList function.
    # 
    # +state_id+ (Numeric, Optional)
    # The state_id of the event, used to narrow down the responses. To get a state_id, try the metro.getStateList function.
    #
    def self.search(query={})
      Mash.new(self.get('/', :query => query.merge({:method => 'metro.search'}).merge(Upcoming.default_options))).rsp.metro
    end
    
    # Retrieve a list of metros for a particular state.
    #
    # +token+ (Required)
    # An authentication token.
    #
    def self.my_list(token)
      token = Upcoming::Auth.token_code(token)
      Mash.new(self.get('/', :query => {:method => 'metro.getMyList', :token => token}.merge(Upcoming.default_options))).rsp.metro
    end
    
    # Retrieve a list of metros for a particular state.
    # 
    # +state_id+ (Required)
    # The state_id number of the state to look within. To find state_id's, use metro.getStateList.
    #
    def self.list(state_id)
      state_id = state_id.join(',') if state_id.is_a?(Array)
      Mash.new(self.get('/', :query => {:method => 'metro.getList', :state_id => state_id}.merge(Upcoming.default_options))).rsp.metro
    end
    
    # Retrieve a list of states for a particular country.
    # 
    # +country_id+ (Required)
    # The country_id number of the country to look within. To find country_id's, use metro.getCountryList.
    #
    def self.state_list(country_id)
      country_id = country_id.join(',') if country_id.is_a?(Array)
      Mash.new(self.get('/', :query => {:method => 'metro.getStateList', :country_id => country_id}.merge(Upcoming.default_options))).rsp.state
    end
    
    # Retrieve a list of all countries in the database.
    #
    def self.country_list
      Mash.new(self.get('/', :query => {:method => 'metro.getCountryList'}.merge(Upcoming.default_options))).rsp.country
    end    
  end
end