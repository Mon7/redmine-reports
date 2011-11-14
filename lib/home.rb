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
    haml :index
  end

  get '/:name.pdf' do |name|
    content_type 'application/pdf'
    response['Content-Disposition'] = "inline; filename=#{name}_#{Date.today.strftime("%B")}.pdf"
    @project = redmine.get_project(name, params[:period])['time_entries']
    @issues = redmine.get_issues(name)['issues']
    pdf(:debiteringsunderlag)
  end
end
