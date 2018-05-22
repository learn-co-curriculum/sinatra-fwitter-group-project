class User < ActiveRecord::Base
<<<<<<< HEAD
  has_many  :tweets
=======
  has_many  :tweets 
>>>>>>> merge conflict resolved

  has_secure_password

  def slug
    username.downcase.gsub(" ","-")
  end

  def self.find_by_slug(slug)
    User.all.find{|user| user.slug == slug}
  end

<<<<<<< HEAD
end
=======
end
>>>>>>> merge conflict resolved
