<<<<<<< HEAD
require 'pry'
describe 'User' do
=======
require 'spec_helper'

describe 'User' do 
>>>>>>> merge conflicts resolved in user spec
  before do
    @user = User.create(:username => "test 123", :email => "test123@aol.com", :password => "test")
  end
  
  it 'can slug the username' do
    expect(@user.slug).to eq("test-123")
  end

  it 'can find a user based on the slug' do
    slug = @user.slug
    expect(User.find_by_slug(slug).username).to eq("test 123")
  end

<<<<<<< HEAD
  it 'has a secure password' do

    expect(@user.authenticate("dog")).to eq(false)

=======
  it 'has a secure password' do 
    expect(@user.authenticate("dog")).to eq(false)
>>>>>>> merge conflicts resolved in user spec
    expect(@user.authenticate("test")).to eq(@user)
  end
end
