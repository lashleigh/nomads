class User < ActiveRecord::Base
  def name
    n = super
    (n.nil? or n == "") ? "Guest_#{id}" : n
  end
end
