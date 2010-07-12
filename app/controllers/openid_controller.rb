require 'openid'
require 'openid/consumer'
require 'openid/extensions/sreg'
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

      sregreq = OpenID::SReg::Request.new
      sregreq.request_fields(['email', 'nickname', 'fullname'], false)
      openid_request.add_extension(sregreq)

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
      user = User.find_by_openid openid_response.identity_url
      unless user
        user = User.new
        user.openid = openid_response.identity_url
        sreg_resp = OpenID::SReg::Response.from_success_response(openid_response)
        if sreg_resp
          user.name = sreg_resp.data['nickname']
          user.fullname = sreg_resp.data['fullname']
          user.email = sreg_resp.data['email']
        end
        user.save
      end

      session[:user] = user.id
      unless user.attributes[:name]
        redirect_to :action => :details 
      else
        redirect_to :controller => :home
      end
    else
      flash[:error] = "Verification of your OpenID login failed: #{openid_response.message}"
      redirect_to :action => :new
    end
  end

  def details
    if params[:user]
      params[:user].reject! { |k,v| k == :openid }
      @user.update_attributes params[:user]
      @user.save
    end
  end

  def destroy
    session[:user] = nil
    redirect_to :controller => :home
  end

  protected
  def openid_consumer
    @openid_consumer ||= OpenID::Consumer.new(session,
      OpenID::Store::Filesystem.new("#{RAILS_ROOT}/tmp/openid"))
  end
end
