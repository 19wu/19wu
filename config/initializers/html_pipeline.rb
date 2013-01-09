HasHtmlPipeline.configure do |config|
  context = {}

  markdown = config.register(:markdown,
                             [
                              HTML::Pipeline::MarkdownFilter,
                              HTML::Pipeline::SanitizationFilter
                             ],
                             context)

  config.register(:profile_markdown,
                  markdown.filters,
                  context)
end
