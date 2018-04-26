
class User < ActiveRecord::Base
  has_secure_password
  has_many :tweets

  def slug
    @slug = self.username.downcase.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    @user = self.all.find { |s| s.slug == slug }
  end

  
  validates :username, presence: true
  validates :email, presence: true

end 


