HasHtmlPipeline.configure do |config|
  context = {}

  config.register(:markdown,
                  [
                   HTML::Pipeline::MarkdownFilter,
                   HTML::Pipeline::SanitizationFilter
                  ],
                  context)
end
