class RegistrationsController < Devise::RegistrationsController
  layout 'settings', :only => [:edit, :update]
end
