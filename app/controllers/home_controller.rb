class HomeController < ApplicationController
  def index
    @photos = FlickrPhoto.find :all, :order => "id DESC", :limit => 5
    @posts = Post.where("published = ?", true).order("created_at DESC").limit(4)
  end
end
