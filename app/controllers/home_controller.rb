class HomeController < ApplicationController
  def index
    @photos = FlickrPhoto.all.reverse
    @posts = Post.all.reverse

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end


end
