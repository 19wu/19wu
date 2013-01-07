class UploadPhotoInput < SimpleForm::Inputs::Base

  def input
    template.tag(:input, :name => 'files[]', :type => 'file', :'data-url' => '/photos', :multiple => true, :class => 'fileupload')
  end
end
