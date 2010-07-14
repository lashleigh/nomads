class User < ActiveRecord::Base
  has_many :suggestions
  has_many :posts
  validates_uniqueness_of :openid
  validates_uniqueness_of :name
  validates_uniqueness_of :email
  def name
    n = super
    (n.nil? or n == "") ? "Guest_#{id}" : n
  end
end
