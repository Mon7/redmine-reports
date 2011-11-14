require './lib/base'

class AuthController < Base
  before do
    unless /^\/log(?:in|out)/ =~ request.path or session[:username]
      return redirect url("/login?return_url=#{request.path}") 
    end
  end
  get '/logout' do
    session[:username] = nil
    redirect '/'
  end
  get '/login' do
    haml :login
  end
  post '/login' do
    session[:username] = params['username']
    session[:password] = params['password']
    return redirect params[:return_url] || '/'
  end
end
