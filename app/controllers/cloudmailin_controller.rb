class CloudmailinController < ApplicationController
  before_filter :verify_signature

  def index
    u = User.find_by_email request[:from]
    if u and u.admin?
      prevPost = Post.last

      p = Post.new
      p.title = request[:subject]
      p.content = request[:plain]
      p.user = u
      p.published = true
      p.lat = prevPost.lat
      p.lon = prevPost.lon
      p.save(false)
      logger.info p.errors.full_messages
    else
      logger.error "Recieved email from untrusted source."
    end

    render :text => "Thank you."
  end

  private
  def verify_signature
    provided = request.request_parameters.delete(:signature)
    signature = Digest::MD5.hexdigest(request.request_parameters.sort.map{|k,v| v}.join + SECRET)

    if provided != signature
      render :text => "Message signature fail #{provided} != #{signature}", :status => 403
      return false 
    end
  end
end
