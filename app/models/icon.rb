class Icon < ActiveRecord::Base
  has_many :suggestions

  def marker_url
    "/images/map_icons/#{name}.png"
  end

  def icon_url
    "/images/map_icons/#{name}.png"
  end
end
