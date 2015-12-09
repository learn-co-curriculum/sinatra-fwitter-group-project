describe 'User' do 
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
end