class Suggestion < ActiveRecord::Base
  belongs_to :icon
  validates_presence_of :name
  validates_presence_of :content

  def as_hash
    { "id" => id,
      "name" => name,
      "latitude" => lat,
      "longitude" => lon,
      "icon_path" => icon.marker_url,
      "content" => content }
  end
end
