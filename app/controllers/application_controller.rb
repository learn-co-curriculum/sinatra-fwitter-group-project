require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "fwitter_secret"
  end

  get '/' do 
    #welcome to fwitter!!! 
    erb :index
  end

  get '/tweets' do 
    #index of all tweets
    if session[:user_id]
      @tweets = Tweet.all
      erb :'tweets/tweets'
    else
      redirect to '/login'
    end   
  end

  get '/tweets/new' do
    #load form to create a new tweet
    if session[:user_id]
      erb :'tweets/create_tweet'
    else
      redirect to '/login'
    end
  end

  post '/tweets' do
    #creates new tweet
    user = User.find_by_id(session[:user_id])
    @tweet = Tweet.create(:content => params[:content], :user_id => user.id)
    redirect to "/tweets/#{@tweet.id}"
  end

  get '/tweets/:id' do 
    #tweets show
    if session[:user_id]
      @tweet = Tweet.find_by_id(params[:id])
      erb :'tweets/show_tweet'
    else 
      redirect to '/login'
    end
  end

  get '/tweets/:id/edit' do  #load edit form
    if session[:user_id] 
      @tweet = Tweet.find_by_id(params[:id])
      erb :'tweets/edit_tweet'
    else
      redirect to '/login'
    end
  end

  post '/tweets/:id' do #edit action
    @tweet = Tweet.find_by_id(params[:id])
    @tweet.content = params[:content]
    @tweet.save
    redirect to "/tweets/#{@tweet.id}"
  end

  post '/tweets/:id/delete' do 
    @tweet = Tweet.find_by_id(params[:id])
    if session[:user_id]
      @tweet = Tweet.find_by_id(params[:id])
      @tweet.delete
      redirect to '/tweets'
    else
      redirect to '/login'
    end
  end


  get '/signup' do
    if !session[:user_id]
      erb :'users/create_user'
    else
      redirect to '/tweets'
    end
  end

  post '/signup' do 
    if params[:username] == "" || params[:email] == "" || params[:password] == ""
      redirect to '/signup'
    else
      @user = User.new(:username => params[:username], :email => params[:email], :password => params[:password])
      @user.save
      session[:user_id] = @user.id
      redirect to '/tweets'
    end
  end

  get '/login' do 
    if !session[:user_id]
      erb :'users/login'
    else
      redirect '/tweets'
    end
  end

  post '/login' do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/tweets"
    else
      redirect to '/signup'
    end
  end

  get '/logout' do
    session.destroy
    redirect '/login'
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end

  end
end