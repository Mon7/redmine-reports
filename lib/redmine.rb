require 'em-http'
require 'em-synchrony/em-http'
require 'json'

class Parser
  def response(resp)
    resp.response = JSON.parse(resp.response) unless resp.response.empty?
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
      :head => {'X-Redmine-API-Key' => ENV['redmine_key']}
    }
  end
  def get name, period
    url = "/projects/#{name}/time_entries.json?period_type=1&period=#{period}"
    @conn.get({:path=>url}.merge(@options)).response
  end
  def projects
    @conn.get({:path=>'/projects.json'}.merge(@options)).response
  end
end
