class TweetController < ApplicationController

  use Rack::Flash

  get "/tweets" do
    if loggedIn
      @user = currentUser
      erb :"tweets/tweets"
    else
      redirect "/login"
    end
  end

  post "/tweets" do
    if !params[:content].nil?
      if params[:content].match(/[^ ]/)
        tweet = Tweet.create(:content => params[:content])
        currentUser.tweets << tweet
        redirect "/tweets/#{tweet.id}"
      else
        flash[:message] = "can't tweet blank tweets dude!"
        redirect "/tweets/new"
      end
    end
  end

  get "/tweets/new" do
    if loggedIn
      @user = currentUser
      erb :"tweets/new"
    else
      redirect "/login"
    end
  end


  get "/tweets/:id"  do
    if loggedIn
      if @tweet = Tweet.find_by(:id => params[:id])
        erb :"tweets/show"
      end
    else
      redirect "/login"
    end
  end

  get "/tweets/:id/edit" do
    if loggedIn
      if @tweet = Tweet.find_by(:id => params[:id])
        erb :"tweets/edit"
      end
    else
      redirect "/login"
    end
  end


  patch "/tweets/:id/edit" do
    @tweet = Tweet.find_by(:id => params[:id])
      if !params[:content].nil? && params[:content].match(/[^ ]/)
        @tweet.update(:content => params[:content])
        redirect "/tweets/#{@tweet.id}"
      else
        flash[:message] = "can't tweet blank tweets dude!"
        redirect "/tweets/#{@tweet.id}/edit"
      end
  end

  delete "/tweets/:id/delete"  do

    if loggedIn
    if @tweet = Tweet.find_by(:id => params[:id])
      @tweet.delete unless @tweet.user_id != currentUser.id
      redirect "/tweets"
    end
    else
      redirect "/login"
    end
  end

end
