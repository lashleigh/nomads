class PostsController < ApplicationController
  before_filter :must_be_admin, :except => [:index, :show]

  # Update Post location
  def update_location
    post = Post.find(params[:id])
    post.lat = params[:lat]
    post.lon = params[:lon]
    post.save
    render :text => post.to_json
  end

  # GET /posts
  # GET /posts.xml
  def index
    if params[:since]
      @posts = Post.published.where("updated_at > ?", params[:since]).order("created_at DESC")
    else
      @posts = Post.published.order("created_at DESC")
      @unpublished = Post.unpublished
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml  => @posts }
      format.json { render :json => @posts.as_json(:only => nil) }
    end
  end

  # GET /posts/1
  # GET /posts/1.xml
  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml   { render :xml  => @post }
      format.json  { render :json => @post.as_json(:only => nil) }
    end
  end

  # GET /posts/new
  # GET /posts/new.xml
  def new
    @post = Post.new
    @post.lat = Post.last.lat
    @post.lon = Post.last.lon
    @post.user = @current_user

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @post }
    end
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  # POST /posts.xml
  def create
    @post = Post.new(params[:post])
    @post.user = @current_user

    respond_to do |format|
      if @post.save
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to(@post) }
        format.xml  { render :xml => @post, :status => :created, :location => @post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /posts/1
  # PUT /posts/1.xml
  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = 'Post was successfully updated.'
        format.html { redirect_to(@post) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.xml
  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end
end
