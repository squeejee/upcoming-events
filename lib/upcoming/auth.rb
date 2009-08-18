module Upcoming
  class Auth
    include Upcoming::Defaults
    
    # Retrieve a token from the site, after the user has given your app an authentication Frob
    #
    # +frob+ (Required)
    # The frob passed back to your application.
    #
    def self.token(frob)
      Mash.new(self.get('/', :query => {:method => 'auth.getToken', :frob => frob}.merge(Upcoming.default_options))).rsp.token.first
    end
    
    # Retrieve a full token from Upcoming, from just the token code. 
    # This method should also be called on saved tokens before proceeding to access user data, 
    # in order to verify that the token has not expired and is valid.
    #
    # +token+ (Required)
    # The token code to check.
    #
    #
    # Step 1: Set up your callback url: http://upcoming.yahoo.com/services/api/keygen.php
    #
    # Step 2: Call http://upcoming.yahoo.com/services/auth/?api_key=Your API Key
    #
    # Step 3: Catch the frob querystring parameter on your callback page and pass to Auth.token
    #
    def self.check_token(token)
      token = Upcoming::Auth.token_code(token)
      Mash.new(self.get('/', :query => {:method => 'auth.checkToken', :token => token}.merge(Upcoming.default_options))).rsp.token.first
    end
    
    # Extracts the token code from a token hash
    #
    def self.token_code(token)
      token.is_a?(Hash) ? token['token'] : token
    end
  end
end