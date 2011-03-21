module ApplicationHelper
  def red(text)
    RedCloth.new(text).to_html.html_safe
  end
  def admin
    @current_user and @current_user.admin?
  end
end
