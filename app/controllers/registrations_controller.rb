class RegistrationsController < Devise::RegistrationsController
  include HasApiResponse
  layout 'settings', :only => [:edit, :update]

  def create
    if request.xhr?
      build_resource(sign_up_params)
      resource.save!
      sign_up(resource_name, resource)
    else
      super
    end
  end
end
