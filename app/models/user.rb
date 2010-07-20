class User < ActiveRecord::Base
  has_many :suggestions
  has_many :posts
  validates_uniqueness_of :openid
  validates_uniqueness_of :name
  validates_uniqueness_of :email
  def nickname
    (self.name.nil? or self.name == "") ? "Guest_#{id}" : self.name
  end
end
