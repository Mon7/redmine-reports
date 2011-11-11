require 'em-http'
require 'em-synchrony/em-http'
require 'json'

class Parser
  def response(resp)
    resp.response = JSON.parse(resp.response)
  end
  def request(client, head, body)
    [head, body]
  end
end

class Redmine
  def initialize
    @conn = EventMachine::HttpRequest.new('http://redmine.mon7.se')
    @conn.use Parser
    @options = {
      :head => {'X-Redmine-API-Key' => '44d0b390b0db2221d0725684b14c639c50d49c45'},
      :limit => 100
    }
  end
  def get name
    url = "/projects/#{name}/time_entries.json?period_type=1&period=last_month"
    @conn.get({:path=>url}.merge(@options)).response
  end
  def projects
    @conn.get({:path=>'/projects.json'}.merge(@options)).response
  end
end
