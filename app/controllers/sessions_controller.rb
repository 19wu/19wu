class SessionsController < Devise::SessionsController
  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    respond_to do |format|
      format.html { redirect_to location: after_sign_in_path_for(resource) }
      format.json
    end
  end
end
