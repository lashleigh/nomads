atom_feed do |feed|
  feed.title("Nomads -- Ashleigh and Benson's Bicycling Adventure")
  #feed.updated(@posts.first.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ"))
 
  @posts.each do |post|
    feed.entry([@project, @type, post]) do |entry|
      entry.title(post.title)
      entry.content(textilize post.content)
      entry.updated(post.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")) # needed to work with Google Reader.
      entry.author do |author|
        author.name(post.user.nickname)
      end
    end
  end
end
