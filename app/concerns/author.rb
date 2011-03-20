module Author
  def author 
    if self.name and self.name != ""
      self.name
    elsif self.fullname and self.fullname != ""
      self.fullname
    else
      "Guest_#{id}"
    end
  end
end
