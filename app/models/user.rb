class User < ActiveRecord::Base
  has_many :suggestions
  has_many :posts
  validates_uniqueness_of :openid
  validates_uniqueness_of :name, :allow_nil => true, :allow_blank => true
  validates_uniqueness_of :email, :allow_nil => true, :allow_blank => true
  def nickname
    (self.name.nil? or self.name == "") ? "Guest_#{id}" : self.name
  end
end
