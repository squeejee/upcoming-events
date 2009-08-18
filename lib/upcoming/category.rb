module Upcoming
  class Category
    include Upcoming::Defaults
    
    # Retrieve a list of valid event categories.
    #
    def self.list
      Mash.new(self.get('/', :query => {:method => 'category.getList'}.merge(Upcoming.default_options))).rsp.category
    end
  end
end