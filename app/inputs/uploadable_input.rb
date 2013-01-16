class UploadableInput < SimpleForm::Inputs::TextInput

  def input
    template.content_tag(:div, :class => @input_html_classes.select {|c| c =~ /span[1-9]+/}.push('uploadable-input')) do
      result = ''
      result += super
      result += template.content_tag(:p, :class => 'upload-panel') do
        template.content_tag(:span, :class => 'default') do
          template.tag(:input, :type => 'file', :multiple => :multiple, 'data-url' => '/photos', :class => 'fileupload manual-file-chooser') +
          template.content_tag(:a, I18n.t('simple_form.hints.photo.upload'), :href => '#')
        end +
        template.content_tag(:span, I18n.t('simple_form.hints.photo.uploading'), :class => 'uploading')
      end
      result.html_safe
    end
  end

end
