require 'html/pipeline'

class ContentFilter
  
  def self.refine(content)
    pipeline = HTML::Pipeline.new [
      HTML::Pipeline::MarkdownFilter
    ]
    pipeline.call(content)[:output].to_s
  end

end
