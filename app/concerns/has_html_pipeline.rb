# TODO: (@doitian) move out as a gem

require 'html/pipeline'

# Usage:
#
#
#     HasHtmlPipeline.register_html_pipeline(:markdown, [HTML::Pipeline::MarkdownFilter])
#
#     class User
#       extend HasHtmlPipeline
#
#       attr_accessor :about
#
#       has_html_pipeline :about, :markdown
#     end
#
#     u = User.new
#     u.about = '# Markdown #'
#     u.about_html # => '<h1>Markdown</h1>'
#
module HasHtmlPipeline
  class << self
    # for `include HasHtmlPipeline`
    def included(klass)
      klass.extend(self)
    end

    def registered_html_pipelines
      @registered_html_pipelines ||= {}
    end

    def register_html_pipeline(name, filters, context = {})
      registered_html_pipelines[name.to_sym] = HTML::Pipeline.new(filters, context)
    end

    alias_method :register, :register_html_pipeline

    def configure
      yield self
    end
  end

  def has_html_pipeline(field, pipeline_name)
    define_method "#{field}_html" do
      pipeline = ::HasHtmlPipeline.registered_html_pipelines[pipeline_name.to_sym]
      pipeline.call(send(field))[:output].to_s
    end
  end
end
