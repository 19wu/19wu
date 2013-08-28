class SessionsController < Devise::SessionsController
  def create
    if request.xhr?
      self.resource = warden.authenticate!(auth_options)
      sign_in(resource_name, resource)
    else
      super
    end
  end
end
