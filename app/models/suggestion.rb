class Suggestion < ActiveRecord::Base
  has_one :waypoint, :as => :position
  has_many :comments, :as => :position
  belongs_to :icon
  belongs_to :user
  validates_presence_of :user_id, :message => "must be logged in"
  validates_presence_of :icon, :message => "must be selected"
  validates_presence_of :title
  validates_presence_of :content
  validates_presence_of :lat
  validates_presence_of :lon

  include SerializationFix
  def serialize_defaults
    {:only => [:id, :title, :lat, :lon], :methods => [:shorten, :to_param]}
  end

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def red(text)
    RedCloth.new(text).to_html.html_safe
  end
  def shorten
    content = self.content
    maxlen = 100
    s = content[0..maxlen]
    if( s.length > maxlen and s.include? ' ')
      red s[0..s.rindex(' ')-1] + '...'
    else
      red s
    end
  end

end
