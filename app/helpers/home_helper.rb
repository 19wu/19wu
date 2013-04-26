module HomeHelper
  
  def active?(current, menu)
    current == menu && :active
  end

end
