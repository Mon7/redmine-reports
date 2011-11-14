require 'json'
require 'httparty'

class Redmine
  include HTTParty
  base_uri('redmine.mon7.se')

  def initialize(user, pass)
    self.class.basic_auth(user, pass)
  end
  def get name, period
    url = "/projects/#{name}/time_entries.json?period_type=1&period=#{period}"
    self.class.get url
  end

  def projects
    self.class.get('/projects.json')
  end
end
