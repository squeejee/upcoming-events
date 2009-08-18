require File.dirname(__FILE__) + '/../test_helper'

class CountryTest < Test::Unit::TestCase
  include Upcoming
  
  context "when using the country API" do
    setup do
      Upcoming.api_key = 'OU812'
    end

    should "retrieve the details about a country" do
      stub_get "http://upcoming.yahooapis.com/services/rest/?method=country.getInfo&country_id=1%2C2%2C3%2C4&api_key=OU812&format=json", 'countries.json'
      countries = Upcoming::Country.info([1,2,3,4])
      countries.first.code.should == 'us'
      countries.last.code.should == 'de'
    end
    
  end
  
end