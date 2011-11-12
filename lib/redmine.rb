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
      :head => {'X-Redmine-API-Key' => ENV['redmine_key']},
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
