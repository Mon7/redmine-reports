require 'json'
require 'httparty'

class Redmine
  include HTTParty
  base_uri('redmine.mon7.se')

  def initialize(user, pass)
    self.class.basic_auth(user, pass)
  end
  def get_project name, period
    url = "/projects/#{name}/time_entries.json?period_type=1&period=#{period}"
    self.class.get url
  end
  def get_issues name
    url = "/projects/#{name}/issues.json?limit=100"
    self.class.get url
  end

  def projects
    self.class.get('/projects.json')
  end
end
