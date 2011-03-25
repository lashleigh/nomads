class Post < ActiveRecord::Base
  def red(text)
    RedCloth.new(text).to_html.html_safe
  end
  def short_content(maxlen = 100)
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
