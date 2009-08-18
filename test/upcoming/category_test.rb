require File.dirname(__FILE__) + '/../test_helper'

class CategoryTest < Test::Unit::TestCase
  include Upcoming
  
  context "when using the category API" do
    setup do
      Upcoming.api_key = 'OU812'
    end

    should "retrieve a list of valid event categories" do
      stub_get "http://upcoming.yahooapis.com/services/rest/?method=category.getList&api_key=OU812&format=json", 'categories.json'
      categories = Upcoming::Category.list
      categories.first.name.should == 'Music'
      categories.last.id.should == 13
    end
    
  end
  
end