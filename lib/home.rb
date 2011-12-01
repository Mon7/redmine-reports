require './lib/base'
require 'pdfkit'

class Home < Base
  helpers do
    def redmine
      Redmine.new(session[:username], session[:password])
    end
  end
  
  get '/' do
    @projects = redmine.projects['projects']
    p @projects
    p 'done'
    haml :index
  end
  get '/statistics' do
    @result = redmine.time_entries(params['period'])
    haml :stat
  end
  get '/statistics/:name' do |name|
    redmine.time_entries(name, params['period']).to_json
  end

  get '/:name.pdf' do |name|
    content_type 'application/pdf'
    response['Content-Disposition'] = "inline; filename=#{name}_#{Date.today.strftime("%B")}.pdf"
    @project = redmine.get_project(name, params[:period])['time_entries'].compact
    @name = @project.first['project']['name']
    @issues = redmine.get_issues(name)['issues']
    pdf(:debiteringsunderlag)
  end
end
