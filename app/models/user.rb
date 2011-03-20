class User < ActiveRecord::Base
  has_many :suggestions
  has_many :posts
  has_many :comments
  validates_uniqueness_of :openid
  validates_uniqueness_of :name, :allow_nil => true, :allow_blank => true
  validates_uniqueness_of :email, :allow_nil => true, :allow_blank => true

  include Author 
  def to_param
    "#{id}-#{author.parameterize}"
  end

  def serializable_hash(options = {})
    options ||= {}
    super({:only => :id, :methods => [:author, :to_param]}.merge(options))
  end

  def get_link
    if self.link and self.link != ""
      return self.link
    else
      return "http://"
    end
  end
end
