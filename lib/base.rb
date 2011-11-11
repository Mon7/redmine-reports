require 'sinatra/base'
require 'sinatra/reloader'
require 'sinatra/synchrony'
require 'haml'

class Base < Sinatra::Base
  register Sinatra::Synchrony

  set :views => lambda {"views/#{self.name.split(/Controller/).first.downcase}"}, :pdf_views => lambda {views + "/pdf"}
  set :haml, :layout => :'/../layout', :format => :html5, :escape_html => true
  before do
    content_type :html, :charset => 'utf-8'
    set :haml, :layout => false if request['X-PJAX']
  end
  configure :development do
    register Sinatra::Reloader
  end
  helpers do
    def pdf(pdf_view)
      html = haml(pdf_view, :views => settings.pdf_views, :layout => false)
      kit = PDFKit.new(html)
      kit.stylesheets << "./assets/css/site.css"
      kit.to_pdf
    end
  end
end
