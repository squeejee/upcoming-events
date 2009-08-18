module Upcoming
  class State
    include Upcoming::Defaults
    
    # +state_id+ (Required)
    # The state_id number of the state to look within. State ID's are referenced in other methods, such as metro.getStateList and metro.getInfo. To run getInfo on multiple states, simply pass an array or a comma-separated list of state_id numbers.
    #
    def self.info(state_id)
      state_id = state_id.join(',') if state_id.is_a?(Array)
      Mash.new(self.get('/', :query => {:method => 'state.getInfo', :state_id => state_id}.merge(Upcoming.default_options))).rsp.state
    end
  end
end