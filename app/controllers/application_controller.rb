require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do 
    erb :index
  end

  get '/signup' do 
    if session[:user_id]
      redirect 'tweets/tweets'
    else 
      erb :index  
    end  

  end 

  post '/signup' do
    @username = params[:username] 
    @password = params[:password]
    @email = params[:email]
    
    if @username == "" || @password == "" || @email == "" 
      redirect '/signup'
    else
      
      session[:user_id] = 1
      redirect 'tweets/tweets'
    end 
  end 

  get '/tweets' do
    if session[:id]
      @tweet= Tweet.all 
      erb :'tweets/tweets'
    else 
      redirect '/login'
    end
  end 

  post '/tweets' do
    if session[:id]
      if params[:content] != ""  
        @tweet = Tweet.create(content: params[:content])

        @user=User.find_by(session[:id]) 
        @tweet.user = @user
        @tweet.save 
        redirect '/tweets'
      else
        redirect '/tweets/new'
      end     
    else
      redirect '/login'
    end
  end

  get '/login' do  
    if session[:id]
      redirect '/tweets'
    else 
      erb :'users/login'
    end 
  end 

  post '/login' do
    @user = User.find_by(username: params[:username])
   
      if @user && user.authenticate(params[:password])
        session[:id] = @user.id
        redirect '/tweets'
      else
        redirect '/login'
      end
  end 

  get '/logout' do
    session.clear
    redirect '/login'
  end 

  get '/users/:slug' do
    @user=User.find_by_slug(params[:slug])
    @tweet=Tweet.all

    erb :'users/show_tweet'
  end

  get '/tweets/new' do 
    if session[:id]
      erb :'tweets/create_tweet'
    else 
      redirect '/login'
    end 
  end    

  get '/tweets/:id' do 
    if session[:id]
      #binding.pry
      @tweet= Tweet.find(params[:id])
      erb :'/tweets/show_tweet'
    else
      redirect "/login"
    end
  end

  get '/tweets/:id/edit' do
    if session[:id]
      @tweet= Tweet.find(params[:id])
      @user=User.find_by(session[:id]) 
         
      erb :'/tweets/edit_tweet'
    else
      redirect "/login"
    end
  end

  patch '/tweets/:id' do
    if session[:id]
      @tweet = Tweet.find(params[:id])
      if params[:content] != ""
        @tweet.update(content: params[:content])
        redirect "/tweets/#{@tweet.id}"
      else
        redirect "/tweets/#{@tweet.id}/edit"
      end
    else
      redirect '/login'
    end
  end

  delete '/tweets/:id/delete' do
    if session[:id]
      
      if Tweet.find(params[:id])
        @tweet = Tweet.find(params[:id])
        @user=User.find_by(session[:id])
        
        if @tweet.user_id == @user.id
            @tweet.delete
        else
          redirect '/tweets'
        end 
        
      else
        redirect '/tweets'
      end
    
    else
      redirect '/login'
    end

  end

end