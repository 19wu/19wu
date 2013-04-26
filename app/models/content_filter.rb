require 'html/pipeline'

class ContentFilter
  
  def self.refine(content)
    filters = HasHtmlPipeline.registered_html_pipelines[:markdown]
    filters.call(content)[:output].to_s
  end

end
