require 'html/pipeline'

class ContentFilter
  
  def self.refine(content)
    pipeline = HasHtmlPipeline.registered_html_pipelines[:markdown]
    pipeline.call(content)[:output].to_s
  end

end
