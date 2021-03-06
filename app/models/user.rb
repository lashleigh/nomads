class User < ActiveRecord::Base
  has_many :suggestions
  has_many :posts
  has_many :comments
  validates_uniqueness_of :openid
  validates_uniqueness_of :name, :allow_nil => true, :allow_blank => true
  validates_uniqueness_of :email, :allow_nil => true, :allow_blank => true

  def display_name 
    if self.name and self.name != ""
      self.name
    elsif self.fullname and self.fullname != ""
      self.fullname
    else
      "Guest_#{id}"
    end
  end

  def to_param
    "#{id}-#{display_name.parameterize}"
  end

  def serializable_hash(options = {})
    options ||= {}
    super({:only => :id, :methods => [:display_name, :to_param]}.merge(options))
  end

  def get_link
    if self.link and self.link != ""
      return self.link
    else
      return "http://"
    end
  end
end
