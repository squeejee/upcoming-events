require File.dirname(__FILE__) + '/../test_helper'

class AuthTest < Test::Unit::TestCase
  include Upcoming
  
  context "when using the authentication API" do
    setup do
      Upcoming.api_key = 'OU812'
    end

    should "retrieve a token from the site" do
      stub_get "http://upcoming.yahooapis.com/services/rest/?method=auth.getToken&frob=123456&api_key=OU812&format=json", 'token.json'
      token = Upcoming::Auth.token(123456)
      token.token.should == "1234567890123456789012345678901234467890"
      token.user_id.should == 674
    end
    
    should "check a token based on the 40-digit token code" do
      stub_get "http://upcoming.yahooapis.com/services/rest/?method=auth.checkToken&token=123456&api_key=OU812&format=json", 'token.json'
      token = Upcoming::Auth.check_token(123456)
      token.token.should == "1234567890123456789012345678901234467890"
      token.user_id.should == 674
    end
  end
  
end