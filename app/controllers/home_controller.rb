class HomeController < ApplicationController
  def index
    @photos = FlickrPhoto.find(:all, :order => "id DESC", :limit => 5)
    @posts = Post.all.reverse
  end
end
