require 'html/pipeline'

class ContentFilter
  
  def self.refine(content)
    HTML::Pipeline::MarkdownFilter.new(content).call
  end

end
