class HomeController < ApplicationController
  def index
    @photos = FlickrPhoto.order("uploaded DESC").limit(5)
    @posts = Post.published.order("created_at DESC").limit(3)
  end
end
