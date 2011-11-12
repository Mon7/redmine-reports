require './lib/base'
require 'pdfkit'

class Home < Base

  helpers do
    def redmine
      Redmine.new
    end
  end
  get '/' do
    @projects = redmine.projects['projects']
    haml :index
  end
  get '/:name.pdf' do |name|
    content_type 'application/pdf'
    response['Content-Disposition'] = "attachment; filename=#{name}_#{Date.today.strftime("%B")}.pdf"
    @project = redmine.get(name, params[:period])['time_entries']
    pdf(:debiteringsunderlag)
  end
end
