require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :sessions_secret, "secret"
  end

  get "/signup" do
    if !logged_in?
      erb :'users/signup'
    else
      redirect '/tweets'
    end
  end

  post "/signup" do
    if params[:username] == "" || params[:password] == "" || params[:email] == ""
      redirect "/signup", :locals => {:message => "*** Please fill-in all fields. ***"}
    elsif
      @user = User.create(username: params[:username], password: params[:password], email: params[:email])
      session[:id] = @user[:id]
      redirect "/tweets"
    else
      erb :'users/signup', :locals => {:message => "*** Please try again. ***"}
    end
  end

  get "/login" do
    if !logged_in?
      erb :'users/login'
    else
      redirect '/tweets'
    end
  end

  post "/login" do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:id] = @user[:id]
      redirect "/tweets"
    else
      erb :'users/login', :locals => {:message => "*** The username and password provided do not match. Please try again. ***"} 
    end
  end

  get "/logout" do
    session.clear
    redirect "/login"
  end

  get "/" do
    erb :index
  end

  get "/tweets" do
    if logged_in?
      @fweets = Tweet.all
      @posts = []
      @fweets.each do |f|
        @posts << {User.find(f.user_id).username => f.content}
      end
      @user = User.find(session[:id])
      erb :'tweets/index'
    else redirect "/login"
    end
  end

  get '/tweets/new' do
    if logged_in?
      erb :'/tweets/new'
    else redirect "/login"
    end
  end

  post '/new' do
    if logged_in? && params[:content] != ""
      @content = params[:content]
      Tweet.create(content: @content, user_id: session[:id])
    else redirect "/login"
    end
    redirect "/tweets"
  end

  get "/users/:slug" do
      @user = User.find_by(username: params[:slug])
      @fweets = Tweet.where(user_id: @user.id)
      erb :'/users/slug'
  end

  get "/tweets/:id" do
    if logged_in?
      @fweet = Tweet.find(params[:id])
      @user = User.find(@fweet.user_id)
      erb :"/tweets/tweet"
    else redirect "/login"
    end
  end

  post "/tweet/:id/delete" do
    if logged_in?
      if params[:delete]
        Tweet.delete(params[:id])
        redirect "/tweets"
      end
    else redirect "/login"
    end
  end

  get "/tweets/:id/edit" do
    if logged_in?
      @fweet = Tweet.find(params[:id])
      erb :"/tweets/edit"
    else redirect "/login"
    end
  end

  post "/tweets/:id/edit" do
    if params[:content] != ''
      @fweet = Tweet.find(params[:id])
      @fweet.content = params[:content]
      @fweet.save
      redirect '/tweets'
    else redirect "/tweets/#{@fweet.user_id}/edit"
    end
  end

private
  helpers do
    def logged_in?
      !!session[:id]
    end

    def current_user
      User.find(session[:id])
    end
  end

end