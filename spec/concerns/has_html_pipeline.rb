require File.expand_path('../../../app/concerns/has_html_pipeline', __FILE__)

describe HasHtmlPipeline do
  context 'when a markdown pipeline has been registered' do
    before do
      HasHtmlPipeline.register_html_pipeline :test, [HTML::Pipeline::MarkdownFilter]
    end

    context 'User has field about and has the markdown pipeline on about' do
      let(:klass) {
        Class.new do
          extend HasHtmlPipeline
          attr_accessor :about
          has_html_pipeline :about, :test
        end
      }
      let(:user) { klass.new }

      context 'when assign about with markdown' do
        before do
          user.about = <<-MD
# Title #

- list item 1
- list item 2
          MD
        end

        subject { user.about_html }

        it { should include('<h1>Title</h1>') }
        it { should include('<li>list item 1</li>') }
        it { should include('<li>list item 2</li>') }
      end
    end
  end
end

