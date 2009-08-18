module Upcoming
  class Group
    include Upcoming::Defaults
    
    # Retrieve group information and metadata for public and private groups.
    #
    # +group_id+ (Required)
    # The id number of the group. You can also pass multiple group_id's separated by commas to getInfo on multiple groups.
    # 
    # +token+ (Optional)
    # An authentication token. Pass to see even private groups.
    #
    def self.info(group_id, token=nil)
      group_id = group_id.join(',') if group_id.is_a?(Array)
      token = token['token'] if token and token['token']
      query = {:method => 'group.getInfo', :group_id => group_id}
      query.merge!(:token => token) if token
      Mash.new(self.get('/', :query => query.merge(Upcoming.default_options))).rsp.group
    end
    
    # Retrieve group member user information and metadata for any public group or private group that the authenticated user is a member of.
    # 
    # +token+ (Required)
    # An authentication token.
    # 
    # +group_id+ (Numeric, Required)
    # The group id requested.
    # 
    # +members_per_page+ (Numeric, Optional)
    # To restrict the number of members per page of results. Default is 100.
    # 
    # +page+ (Numeric, Optional)
    # Page # to return. Starts with 1.
    # 
    # +order+ (Either 'member_timestamp' or 'username', default: 'username')
    # Member_timestamp orders by date joined.
    # 
    # +dir+ (Either 'asc' or 'desc', default: asc)
    # Sort direction.
    #
    def self.members(group_id, token, options={})
      opts = {:membersPerPage => 100, :page => 1, :order => 'username', :dir => 'asc'}
      opts.merge! options
      opts[:membersPerPage] = opts.delete(:members_per_page) if opts[:members_per_page]
      token = token['token'] if token and token['token']
      query = {:method => 'group.getMembers', :group_id => group_id, :token => token}
      Mash.new(self.get('/', :query => query.merge(opts).merge(Upcoming.default_options))).rsp.user
    end
    
    # Retrieve group event information and metadata for any public group or private group that the authenticated user is a member of.
    # 
    # +token+ (Optional)
    # An authentication token. 
    # 
    # +group_id+ (Numeric, Required)
    # The group id requested.
    # 
    # +events_per_page+ (Numeric, Optional)
    # To restrict the number of members per page of results.
    # 
    # +page+ (Numeric, Optional)
    # Page # to return. Starts with 1.
    # 
    # +order+ (Either 'event_time' or 'time_added', default: 'event_time')
    # Event_time orders by event start date, time_added orders by the time the event was added to the group.
    # 
    # +dir+ (Either 'asc' or 'desc', default: asc)
    # Sort direction.
    # 
    # +show_past+ (Either 1 or 0, default: 0)
    # Whether to exclusively show past results (instead of upcoming) in the event results.
    def self.events(group_id, token, options={})
      opts = {:eventsPerPage => 100, :page => 1, :order => 'event_time', :dir => 'asc', :show_past => 0}
      opts.merge! options
      opts[:eventsPerPage] = opts.delete(:events_per_page) if opts[:events_per_page]
      token = token['token'] if token and token['token']
      query = {:method => 'group.getEvents', :group_id => group_id, :token => token}
      Mash.new(self.get('/', :query => query.merge(opts).merge(Upcoming.default_options))).rsp.event
    end
    
    # Retrieve group information and metadata for all groups that the authenticated user is a member of. This method requires authentication.
    # 
    # +token+ (Required)
    # An authentication token.
    def self.my_groups(token)
      Mash.new(self.get('/', :query => {:method => 'getMyGroups', :token => token}.merge(Upcoming.default_options))).rsp.event
    end
    
    # Add a new group to the database. This method requires authentication.
    # 
    # +token+ (Required)
    # An authentication token. 
    # 
    # +name+ (Required)
    # The name of the group.
    # 
    # +description+ (Optional)
    # The group's description. May contain some HTML.
    # 
    # +event_moderation+ (Numeric, either 1 or 0)
    # Whether to enable moderation of event suggestions. Default is 0.
    # 
    # +member_moderation+ (Numeric, either 1 or 0)
    # Whether to enable moderation of new members. Default is 0.
    # 
    # +is_private+ (Number, 1 or 0)
    # Indicates whether it should be a private, invite-only group(1), or available for public view and searching (0).
    def self.add(info, token)
      token = Upcoming::Auth.token_code(token)
      format :xml
      body = {:method => 'group.add', :token => token}
      body.merge!(info)
      body.merge!(Upcoming.default_options)
      body.merge!({:format => 'xml'})
      Mash.new(self.post('/', :body => body)).rsp.group
    end
    
    # Edit a group. Only an admin of a group may edit it.This method requires authentication.
    # 
    # +token+ (Required)
    # An authentication token. 
    # 
    # +group_id+ (Numeric, Required)
    # The id of the group to edit.
    # 
    # +name+ (Required)
    # The name of the group.
    # 
    # +description+ (Optional)
    # The group's description. May contain some HTML.
    # 
    # +event_moderation+ (Numeric, either 1 or 0)
    # Whether to enable moderation of event suggestions. Default is 0.
    # 
    # +member_moderation+ (Numeric, either 1 or 0)
    # Whether to enable moderation of new members. Default is 0.
    # 
    # +is_private+ (Number, 1 or 0)
    # Indicates whether it should be a private, invite-only group(1), or available for public view and searching (0).
    # 
    def self.edit(group, token)
      token = Upcoming::Auth.token_code(token)
      format :xml
      body = {:method => 'group.edit', :token => token}
      body.merge!(info)
      body.merge!(Upcoming.default_options)
      body.merge!({:format => 'xml'})
      Mash.new(self.post('/', :body => body)).rsp.group
    end
    
    # Try to join a group. If the group is moderated, the request may be queued for administrator review instead of processed immediately. This method requires authentication.
    # 
    # +token+ (Required)
    # An authentication token. 
    # 
    # +group_id+ (Required)
    # The id of the group to join.
    def self.join(group_id, token)
      token = Upcoming::Auth.token_code(token)
      format :xml
      body = {:method => 'group.join', :group_id => group_id,  :token => token}
      body.merge!(Upcoming.default_options)
      body.merge!({:format => 'xml'})
      Mash.new(self.post('/', :body => body)).rsp.group
    end
    
    # Try to leave a group. If the user leaving was the last member of the group, the group is permanently deleted, and may not be rejoined. If the user who left was the last admin in the group, the user remaining with the earliest join timestamp becomes an admin. This method requires authentication.
    # 
    # +token+ (Required)
    # An authentication token. 
    # 
    # +group_id+ (Required)
    # The id of the group to leave.
    def self.leave(group_id, token)
      token = Upcoming::Auth.token_code(token)
      format :xml
      body = {:method => 'group.leave', :group_id => group_id,  :token => token}
      body.merge!(Upcoming.default_options)
      body.merge!({:format => 'xml'})
      Mash.new(self.post('/', :body => body)).rsp.stat == 'ok'
    end
    
    # Try to add an event to a group. If the group is moderated, the request may be queued for administrator review instead of processed immediately.This method requires authentication.
    # 
    # +token+ (Required)
    # An authentication token. 
    # 
    # +group_id+ (Required)
    # The id of the group.
    # 
    # +event_id+ (Required)
    # The id of the event to send.
    #
    def self.add_event(group_id, event_id, token)
      token = Upcoming::Auth.token_code(token)
      format :xml
      body = {:method => 'group.addEventTo', :group_id => group_id,  :event_id => event_id, :token => token}
      body.merge!(Upcoming.default_options)
      body.merge!({:format => 'xml'})
      Mash.new(self.post('/', :body => body)).rsp.group
    end
    
    # Try to remove an event to a group. This method can only be called by an authenticated group admin, or by the user who added the event to the group. This method requires authentication.
    # 
    # +token+ (Required)
    # An authentication token. 
    # 
    # +group_id+ (Required)
    # The id of the group.
    # 
    # +event_id+ (Required)
    # The id of the event to remove.
    #
    def self.remove_event(group_id, event_id, token)
      token = Upcoming::Auth.token_code(token)
      format :xml
      body = {:method => 'group.removeEvent', :group_id => group_id, :event_id => event, :token => token}
      body.merge!(Upcoming.default_options)
      body.merge!({:format => 'xml'})
      Mash.new(self.post('/', :body => body)).rsp.stat == 'ok'
    end
    
  end
end