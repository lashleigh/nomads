class ActivityController < ApplicationController
  before_filter :set_items
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml  => @items }
      format.json { render :json => @items }
    end
  end

  def plain
    @urls = @items.collect do |item|
      url_for item
    end

    @items.collect! do |item|
      if Comment === item
        "#{item.user.author} commented on #{item.position.title}"
      elsif Post === item 
        "#{item.user.author} wrote a blog post #{item.title}"
      elsif Suggestion === item 
        "#{item.user.author} suggested #{item.title}"
      end 
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @items.zip(@urls) }
    end
  end

  private
  def set_items
    n = params[:n].to_i
    if n <= 0
      # Default number of items
      n = 15
    end
    suggestions = Suggestion.order("created_at DESC")
    comments = Comment.order("created_at DESC")
    posts = Post.published.order("created_at DESC")
    @items = (suggestions + comments + posts).sort_by { |i| i.created_at }.last(n).reverse
  end
end
