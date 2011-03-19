class HomeController < ApplicationController
  def index
    @photos = FlickrPhoto.order("id DESC").limit(5)
    @posts = Post.published.order("created_at DESC").limit(3)
  end
end
