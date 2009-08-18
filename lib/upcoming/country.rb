module Upcoming
  class Country
    include Upcoming::Defaults
    
    # +country_id+ (Required)
    # The country_id number of the country to look within. Country ID's are referred to within other API methods, such as metro.getStateList and state.getInfo. To run getInfo on multiple countries, simply pass an array or a comma-separated list of country_id numbers.
    #
    def self.info(country_id)
      country_id = country_id.join(',') if country_id.is_a?(Array)
      Mash.new(self.get('/', :query => {:method => 'country.getInfo', :country_id => country_id}.merge(Upcoming.default_options))).rsp.country
    end
  end
end