class SlugConstraint
  def self.matches?(request)
    Group.exists? :slug => request.path_parameters[:slug]
  end
end
