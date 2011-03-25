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
  def serialize_defaults
    {:only => [:id, :title, :lat, :lon], :methods => [:short_content, :to_param]}
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end
  def red(text)
    RedCloth.new(text).to_html.html_safe
  end
  def short_content(maxlen = 175)
    s = content[0..maxlen]
    if( s.length > maxlen and s.include? ' ')
      red s[0..s.rindex(' ')-1] + '...'
    else
      red s
    end
  end

  def published= v
    # If we're setting published to true, AND there's a created_at value, update it
    if v and self.created_at and not self.published
      self.created_at = Time.now
    end
    super v
  end
end
