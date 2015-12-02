require 'spec_helper'

describe ApplicationController do


  it 'loads the homepage' do 
    get '/'
    expect(last_response.status).to eq(200)
    expect(last_response.body).to include("Welcome to Fwitter")
  end

  it 'loads the signup page' do 
    get '/signup'
    expect(last_response.status).to eq(200)
  end

  it 'signup directs user to twitter index' do 
    params = {
      :username => "skittles123",
      :email => "skittles@aol.com",
      :password => "rainbows"
    }
    post '/signup', params
    expect(last_response.location).to eq("http://example.org/tweets") 
  end

  it 'loads the login page' do
    get '/login' 
    expect(last_response.status).to eq(200)
  end

  it 'loads the tweets index after login' do
    user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
    params = {
      :username => "becky567",
      :password => "kittens"
    }
    post '/login', params
    expect(last_response.status).to eq(302)
    expect(last_response.location).to eq("http://example.org/tweets")
  end

  
  it 'redirects to login after logout' do 
    get '/logout' 
    expect(last_response.location).to eq("http://example.org/login")
  end

  it 'does not load /tweets if user not logged in' do 
    get '/tweets'
    expect(last_response.location).to eq("http://example.org/login")
  end 

  it 'does load /tweets if user is logged in' do
    user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

    visit '/login'

    fill_in(:username, :with => "becky567")
    fill_in(:password, :with => "kittens")
    click_button 'submit'
    expect(page.current_path).to eq('/tweets')


  end

  it 'lets user view new tweet form if not logged in' do
    user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

    visit '/login'

    fill_in(:username, :with => "becky567")
    fill_in(:password, :with => "kittens")
    click_button 'submit'
    visit '/tweets/new'
    expect(page.status_code).to eq(200)


  end

  it 'does not let user view new tweet form if not logged in' do 
    get '/tweets/new'
    expect(last_response.location).to eq("http://example.org/login")
  end 

  it 'lets user create a tweet if they are logged in' do
    user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")

    visit '/login'

    fill_in(:username, :with => "becky567")
    fill_in(:password, :with => "kittens")
    click_button 'submit'
    
    visit '/tweets/new'
    fill_in(:content, :with => "tweet!!!")
    click_button 'submit'

    expect(Tweet.find_by(:content => "tweet!!!")).to be_instance_of(Tweet)  
    expect(page.status_code).to eq(200)


  end

  it 'lets a user view tweet edit form if they are logged in' do
    user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
    tweet = Tweet.create(:content => "tweeting!", :user_id => 1)
    visit '/login'

    fill_in(:username, :with => "becky567")
    fill_in(:password, :with => "kittens")
    click_button 'submit'
    visit '/tweets/1/edit'
    expect(page.status_code).to eq(200)
  end

  it 'does not load let user view tweet edit form if not logged in' do 
    get '/tweets/1/edit'
    expect(last_response.location).to eq("http://example.org/login")
  end 

  it 'lets a user edit tweet if they are logged in' do
    user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
    tweet = Tweet.create(:content => "tweeting!", :user_id => 1)
    visit '/login'

    fill_in(:username, :with => "becky567")
    fill_in(:password, :with => "kittens")
    click_button 'submit'
    visit '/tweets/1/edit'

    fill_in(:content, :with => "i love tweeting")

    click_button 'submit'
    expect(Tweet.find_by(:content => "i love tweeting")).to be_instance_of(Tweet)  
    expect(Tweet.find_by(:content => "tweeting!")).to eq(nil)  

    expect(page.status_code).to eq(200)
  end


  it 'lets a user delete a tweet if they are logged in' do
    user = User.create(:username => "becky567", :email => "starz@aol.com", :password => "kittens")
    tweet = Tweet.create(:content => "tweeting!", :user_id => 1)
    visit '/login'

    fill_in(:username, :with => "becky567")
    fill_in(:password, :with => "kittens")
    click_button 'submit'
    visit 'tweets/1'
    click_button "Delete Tweet"
    expect(page.status_code).to eq(200)
    expect(Tweet.find_by(:content => "tweeting!")).to eq(nil)
  end

  it 'does not load let user delete a tweet if not logged in' do 
    tweet = Tweet.create(:content => "tweeting!", :user_id => 1)
    visit '/tweets/1'
    expect(page.current_path).to eq("/login")
  end


end