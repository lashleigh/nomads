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
    @items.collect! do |item|
      if Comment === item
        "#{item.author} commented on #{item.position.title}"
      elsif Post === item 
        "#{item.author} wrote a blog post #{item.title}"
      elsif Suggestion === item 
        "#{item.author} suggested #{item.title}"
      end 
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @items }
    end
  end

  private
  def set_items
    n = params[:n].to_i
    if n <= 0
      # Default number of items
      n = 12
    end
    suggestions = Suggestion.find :all, :order => "created_at DESC"
    comments = Comment.find :all, :order => "created_at DESC"
    posts = Post.find :all, :order => "created_at DESC"
    @items = (suggestions + comments + posts).sort_by { |i| i.created_at }.last(n).reverse
  end
end
