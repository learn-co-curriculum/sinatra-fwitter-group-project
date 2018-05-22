<<<<<<< HEAD
require 'pry'
=======
require 'spec_helper'

>>>>>>> enforce_ar_version
describe 'User' do 
  before do
    @user = User.create(:username => "test 123", :email => "test123@aol.com", :password => "test")
  end
  it 'can slug the username' do
    expect(@user.slug).to eq("test-123")
  end

<<<<<<< HEAD
  it 'can find a user based on the slug' do 
=======
  it 'can find a user based on the slug' do
>>>>>>> enforce_ar_version
    slug = @user.slug
    expect(User.find_by_slug(slug).username).to eq("test 123")
  end

<<<<<<< HEAD
  it 'has a secure password' do 
    
    expect(@user.authenticate("dog")).to eq(false)

    expect(@user.authenticate("test")).to eq(@user)
  end
end
=======
  it 'has a secure password' do

    expect(@user.authenticate("dog")).to eq(false)
    expect(@user.authenticate("test")).to eq(@user)

  end
end
>>>>>>> enforce_ar_version
