class SuggestionsController < ApplicationController
  before_filter :must_be_user, :except => [:index, :show]
  before_filter :display_icons
  layout 'posts'

  # Updates the location of a suggestion
  def update_location
    suggestion = Suggestion.find(params[:id])
    if @user.admin? or suggestion.user == @user
      suggestion.lat = params[:lat]
      suggestion.lon = params[:lon]
      suggestion.save
    end
    render :text => suggestion.to_json
  end

  # GET /suggestions
  # GET /suggestions.xml
  def index
    if params[:since]
      all = Suggestion.find(:all, :conditions => [ "updated_at > ?",  params[:since] ]).reverse
    else
      all = Suggestion.find(:all).reverse
    end

    if @user
      # Put the user's suggestions at the top
      @suggestions = @user.suggestions.reverse + (all - @user.suggestions)
    else
      @suggestions = all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml  => @suggestions }
      format.json { render :json => @suggestions.to_json(:only => nil) }
    end
  end

  # GET /suggestions/1
  # GET /suggestions/1.xml
  # GET /suggestions/1.json
  def show
    @suggestion = Suggestion.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @suggestion }
      format.json { render :json => @suggestion.to_json(:only => nil) }
    end
  end

  # GET /suggestions/new
  # GET /suggestions/new.xml
  def new
    @suggestion = Suggestion.new
    @suggestion.lat = params[:lat]
    @suggestion.lon = params[:lng]

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @suggestion }
    end
  end

  # GET /suggestions/1/edit
  def edit
    @suggestion = Suggestion.find(params[:id])
  end

  # POST /suggestions
  # POST /suggestions.xml
  def create
    unless @user
      flash[:error] = "You must be logged in to create a suggestion"
      redirect_to(suggestions_url)
      return
    end

    @suggestion = Suggestion.new(params[:suggestion])
    @suggestion.user = @user

    respond_to do |format|
      if @suggestion.save
        flash[:notice] = 'Suggestion was successfully created.'
        format.html { redirect_to(@suggestion) }
        format.js   { render :json => @suggestion.to_json(:include => [:icon, :user], :method => :to_param)}
        format.xml  { render :xml => @suggestion, :status => :created, :location => @suggestion }
      else
        format.html { render :action => "new" }
        format.js   { render :json => { :errors => @suggestion.errors.full_messages } }
        format.xml  { render :xml => @suggestion.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /suggestions/1
  # PUT /suggestions/1.xml
  def update
    @suggestion = Suggestion.find(params[:id])
    values = params[:suggestion]
    values.reject! { |k,v| k == :user_id }

    respond_to do |format|
      if @user and (@user.admin? or @suggestion.user == @user)
        if @suggestion.update_attributes(params[:suggestion])
          flash[:notice] = 'Suggestion was successfully updated.'
          format.html { redirect_to(@suggestion) }
          format.xml  { head :ok }
        else
          #format.html { redirect_to edit_suggestion_path }
          format.html { render :action => "edit" }
          format.xml  { render :xml => @suggestion.errors, :status => :unprocessable_entity }
        end
      else
        format.html do
          flash[:error] = "Sorry that suggestion does not belong to you."
          redirect_to(@suggestion)
        end
        format.xml { render :xml => "That suggestion does not belong to you." }
      end
    end
  end

  # DELETE /suggestions/1
  # DELETE /suggestions/1.xml
  def destroy
    @suggestion = Suggestion.find(params[:id])
    if @user and (@user.admin? or @suggestion.user == @user)
      @suggestion.destroy
    else
      flash[:error] = "It appears you attempted to delete a suggestion that you did not create. Perhaps you need to log in?"
    end

    respond_to do |format|
      format.html { redirect_to(suggestions_url) }
      format.xml  { head :ok }
    end
  end

  private
  def display_icons
    @icons = Icon.all
  end
end
