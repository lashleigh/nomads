class User < ActiveRecord::Base
  has_many :suggestions
  has_many :posts
  has_many :comments
  validates_uniqueness_of :openid
  validates_uniqueness_of :name, :allow_nil => true, :allow_blank => true
  validates_uniqueness_of :email, :allow_nil => true, :allow_blank => true
  def nickname
    if self.name and self.name != ""
      self.name
    elsif self.fullname and self.fullname != ""
      self.fullname
    else
      "Guest_#{id}"
    end
  end

  def get_link
    if self.link != ""
      return self.link
    else
      return "http://"
    end
  end
end
