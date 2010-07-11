require 'openid'
require 'openid/consumer'
require 'openid/store/filesystem'

class OpenidController < ApplicationController
  def index
    redirect_to :action => :new
  end

  def create
    begin
      openid_request = openid_consumer.begin params[:openid_url]
      return_to = url_for :action => 'complete', :only_path => false
      realm = url_for :action => 'index', :only_path => false
      redirect_to openid_request.redirect_url(realm, return_to)
    rescue OpenID::DiscoveryFailure
      flash[:error] = "Couldn't find an OpenID for the specified URL"
      render :action => :new
    end
  end

  def complete
    current_url = url_for(:action => 'complete', :only_path => false)
    parameters = params.reject { |k,v| request.path_parameters[k] }
    openid_response = openid_consumer.complete parameters, current_url

    if openid_response.status == OpenID::Consumer::SUCCESS
      logger.info "Successful Login: ", openid_response.to_json
      session[:openid] = openid_response.identity_url
      redirect_to :controller => :home
    else
      flash[:error] = "Verification of your OpenID login failed: #{openid_response.message}"
      redirect_to :action => :new
    end
  end

  protected
  def openid_consumer
    @openid_consumer ||= OpenID::Consumer.new(session,
      OpenID::Store::Filesystem.new("#{RAILS_ROOT}/tmp/openid"))
  end
end
