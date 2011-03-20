class Icon < ActiveRecord::Base
  has_many :suggestions

  def serializable_hash(options = {})
    options ||= {}
    super({:only => [:name, :description], :methods => :marker_url}.merge(options))
  end

  def marker_url
    "/images/map_icons/#{name}.png"
  end
end
