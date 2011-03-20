class IconsController < ApplicationController
  def show
    icon = Icon.find(params[:id])
    @suggestions = Suggestion.where("icon_id=?", icon.id)
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @suggestion }
      format.json  { render :json => @suggestion }
    end
  end
end
