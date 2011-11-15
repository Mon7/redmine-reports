class TimeEntry
  attr_accessor :spent_time, :date

  def initialize date
    @date = Date.parse(date)
    @spent_time = 0
  end
end
class Project
  attr_accessor :name, :time_entries

  def initialize name
    @name = name
    @time_entries = []
  end
  def add_time_entry(time, date)
    @time_entries << tt = TimeEntry.new(date) unless tt = @time_entries.find {|tt| tt.date == Date.parse(date) }
    tt.spent_time += time
  end
  def total_time
    @time_entries.collect { |te| te.spent_time }.inject(:+)
  end
  def period
    dates = []
    count = @time_entries.size
    step = count/6
    i = step
    @time_entries.each do |tt|
      i += 1
      next if i <= step
      i = 0
      dates << tt.date
    end
    dates
  end
  def entry_points
    @time_entries.collect do |tt|
      tt.spent_time
    end
  end
  def linechart_url
    upper_value = entry_points.max * 1.2
    url = "http://chart.apis.google.com/chart"
    url += "?chxl=0:|#{period.join('|')}"
    url += "&chxs=0,00AA00,14,0.5,l,676767"
    url += "&chxt=x,y"
    url += "&chxr=1,0,#{upper_value}"
    url += "&chs=700x350"
    url += "&cht=lc"
    url += "&chco=0000FF"
    url += "&chds=0,#{upper_value}"
    url += "&chd=t:#{entry_points.join(',')}"
    url += "&chg=20,25"
    url += "&chls=3,3,4"
  end
end
class Result
  attr_accessor :projects
  def initialize
    @projects = []
  end
  def project_names
    @projects.collect {|p| p.name}.join('|')
  end
  def add_project(name, time_entry)
    @projects << p = Project.new(name) unless p = @projects.find { |p| p.name == name }
    p.add_time_entry(time_entry['hours'], time_entry['spent_on'])
  end
  def total_time
    @projects.collect do |p|
      p.total_time
    end.inject(:+)
  end
  def project_distribution
    tt = total_time
    @projects.collect do |p|
      100*((p.total_time.to_f/tt).round(2))
    end
  end
  def piechart_url
    url = "http://chart.googleapis.com/chart?chs=770x385&cht=p&chco=FA0A0A,00FF00"
    url += "&chd=t:#{ project_distribution.join(',')}"
    url += "&chdl=#{ project_names }"
    url += "&chp=0.033&chl=#{project_distribution.join('|') }"
    url += "&chtt=Procentuell+F%C3%B6r%C3%A4ndring" 
    url
  end
end
