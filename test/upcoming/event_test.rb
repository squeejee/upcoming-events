require File.dirname(__FILE__) + '/../test_helper'

class EventTest < Test::Unit::TestCase
  include Upcoming
  
  context "when using the events API" do
    setup do
      Upcoming.api_key = 'OU812'
    end

    should "retrieve info for a single event" do
      stub_get "http://upcoming.yahooapis.com/services/rest/?method=event.getInfo&event_id=123456&api_key=OU812&format=json", 'event.json'
      event = Upcoming::Event.info(123456).first
      event.name.should == "Def Leppard Dallas TX"
      event.venue_id.should == 115339
      event.latitude.should == 32.7743
    end
    
    should "retrieve info for multiple events" do
      stub_get "http://upcoming.yahooapis.com/services/rest/?method=event.getInfo&event_id=123456%2C654321&api_key=OU812&format=json", 'events.json'
      event = Upcoming::Event.info([123456, 654321]).last
      event.name.should == "Disney&#39;s A CHRISTMAS CAROL Train Tour"
      event.venue_name.should == "Union Station - Amtrak"
      event.ticket_free.should == 1
    end
    
    context "when authenticated" do
      setup do
        stub_get "http://upcoming.yahooapis.com/services/rest/?method=auth.getToken&frob=123456&api_key=OU812&format=json", 'token.json'
        @token = Upcoming::Auth.token(123456)
      end

      should "add an event" do
        stub_post "http://upcoming.yahooapis.com/services/rest/?", 'new_event.xml'
        stub_get "http://upcoming.yahooapis.com/services/rest/?method=event.getInfo&event_id=1&token=1234567890123456789012345678901234467890&api_key=OU812&format=json", 'new_event.json'
        
        event_info = Mash.new
        event_info.name = "Tori Amos, Ben Folds"
        event_info.venue_id = 1
        event_info.category_id = 1
        event_info.start_date = '2003-08-01'
        
        event = Upcoming::Event.add(event_info, @token)
        event.name.should == "Tori Amos, Ben Folds"
        event.venue_id.should == 1
        event.category_id.should == 1
        event.start_date.year.should == 2003
      end
      
      should "add an event" do
        stub_post "http://upcoming.yahooapis.com/services/rest/?", 'new_event.xml'
        stub_get "http://upcoming.yahooapis.com/services/rest/?method=event.getInfo&event_id=1&token=1234567890123456789012345678901234467890&api_key=OU812&format=json", 'saved_event.json'
        
        event_info = Mash.new
        event_info.name = "Tori Amos, Ben Folds"
        event_info.venue_id = 1
        event_info.category_id = 1
        event_info.start_date = '2003-08-01'
        
        event = Upcoming::Event.edit(event_info, @token)
        event.name.should == "Tori Amos, Ben Folds"
        event.venue_id.should == 1
        event.category_id.should == 1
        event.start_date.year.should == 2003
        event.photo_url.should == 'http://flickr.com'
      end
      
      should_eventually "tag an event" do
      end
      
      should_eventually "remove tag from an event" do
        
      end
      
      should_eventually "search for public events by multiple facets" do
        
      end
      
      should_eventually "get a watchlist for an event" do
        
      end
      
      should_eventually "retrieve groups watching an event " do
        
      end
      
      should_eventually "search for featured or popular events in a specified place" do
        
      end
    end
  end
  
end
