class UserController < ApplicationController

  use Rack::Flash

  get "/signup" do
    if loggedIn
      redirect "/tweets"
    else
      erb :"users/signup"
    end
  end

  get "/login" do
    if loggedIn
      redirect "/tweets"
    else
      erb :"users/login"
    end
  end

  get '/logout' do
    session.clear
    redirect "/login"
  end

  get '/users/:slug' do
    if @user = User.find_by_slug(params[:slug])
      erb :"tweets/tweets_by"
    end
  end

  post "/signup" do
    if params[:email] == "" || params[:password]== "" || params[:username] == ""
      flash[:message] = "Please fill in required fields"
      redirect "/signup"
    else
      @user = User.create(:username => params[:username], :password => params[:password], :email => params[:email])
      session[:id] = @user.id
      redirect "/tweets"
    end
  end

  post "/login" do
    if params[:password]== "" || params[:username] == ""
      flash[:message] = "Please fill in required fields"
      redirect "/login"
    else
      @user = User.find_by(:username => params[:username])
      if @user && @user.authenticate(params[:password])
        session[:id] = @user.id
        redirect "/tweets"
      else
        flash[:message] = "Wrong username or password"
        redirect "/login"
      end
    end
  end

end
