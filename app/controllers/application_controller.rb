require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    enable :sessions
    set :session_secret, "secrete"
    set :public_folder, "public"
    set :views, "app/views"
    set :method_override, true
  end

  get "/" do
   if loggedIn
     redirect "/tweets"
   end
    erb :index
  end

  helpers do

    def loggedIn
      !!session[:id]
    end

    def currentUser
      User.find_by(id: session[:id])
    end

  end

end
