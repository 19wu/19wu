class UploadableInput < SimpleForm::Inputs::TextInput

  def input
    template.content_tag(:div, :class => @input_html_classes.select {|c| c =~ /span[1-9]+/}.push('uploadable-input')) do
      result = ''
      
      result += template.content_tag(:ul, :class => 'uploadable-nav') do
        
      template.content_tag(:li, :class => 'write-tab active') do
          template.content_tag(:a, I18n.t('simple_form.navtabs.write'), :href => '#', 'data-toggle' => 'tab')
        end+

        template.content_tag(:li, :class => 'preview-tab') do
          template.content_tag(:a, I18n.t('simple_form.navtabs.preview'), :href => '#', 'data-toggle' => 'tab')
        end
      end
      
      result += template.content_tag(:div, :class => 'tab-content') do
        template.content_tag(:div, :class => 'tab-pane fade in active write-pane') do
          super
        end +
        template.content_tag(:div, :class => 'tab-pane fade preview-pane') do
          template.content_tag(:div, :class => 'previews') do
          end+
          template.content_tag(:p, I18n.t('simple_form.hints.preview.nothing'), :class => 'preview-hint preview-nothing')+
          template.content_tag(:p, I18n.t('simple_form.hints.preview.loading'), :class => 'preview-hint preview-loading')
        end 
      end

      result += template.content_tag(:p, :class => 'upload-panel') do
        template.content_tag(:span, :class => 'default') do
          template.tag(:input, :type => 'file', :multiple => :multiple, 'data-url' => '/photos', :class => 'fileupload manual-file-chooser') +
          template.content_tag(:a, I18n.t('simple_form.hints.photo.upload'), :href => '#') +
          template.content_tag(:a, I18n.t('labels.markdown_guide') , :class => 'pull-right', 'data-toggle' => 'modal', :href => '#markdownModal')
        end +
        template.content_tag(:span, I18n.t('simple_form.hints.photo.uploading'), :class => 'uploading')
      end
      result.html_safe
    end
  end

end
