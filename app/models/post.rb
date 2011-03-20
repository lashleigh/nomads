class Post < ActiveRecord::Base
  scope :published, where("published=?", true)
  scope :unpublished, where("published=?", false)
  validates_presence_of :user
  validates_presence_of :title
  validates_presence_of :content
  validates_presence_of :lat
  validates_presence_of :lon
  has_many :comments, :as => :position, :dependent => :destroy
  has_one :waypoint, :as => :position
  belongs_to :user

  include SerializationFix
  include Author 
  def serialize_defaults
    {:only => [:title, :lat, :lon], :methods => [:short_content, :to_param]}
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def short_content(maxlen = 100)
    s = content[0..maxlen]
    if( s.length > maxlen and s.include? ' ')
      s[0..s.rindex(' ')-1] + '...'
    else
      s
    end
  end

  def author
    if user
      user.name
    else
      "unknown"
    end
  end

  def published= v
    super v
    # If we're setting published to true, AND there's a created_at value, update it
    if v and self.created_at
      self.created_at = Time.now
    end
  end
end
