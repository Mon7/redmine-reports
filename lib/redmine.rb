require 'json'
require 'httparty'

class Redmine
  include HTTParty
  base_uri('redmine.mon7.se')

  def initialize(user, pass)
    self.class.basic_auth(user, pass)
  end
  def get_project name, period
    url = "/projects/#{name}/time_entries.json?period_type=1&period=#{period}&limit=100&offset=0"
    res = self.class.get(url)
    count = res['total_count'].to_i
    nr_of_time_entries = ((count - 100)/100.0).ceil
    nr_of_time_entries.times do |i|
      url = "/projects/#{name}/time_entries.json?period_type=1&period=#{period}&limit=100&offset=#{100 * (i + 1)}"
      res['time_entries'] += self.class.get(url)['time_entries']
    end
    res
  end
  def get_issues name
    url = "/projects/#{name}/issues.json?limit=100"
    self.class.get url
  end

  def projects
    self.class.get('/projects.json')
  end
end
