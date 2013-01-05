require 'kramdown'

module GitHub
  class Markdown
    def self.to_html(content, ignore)
      Kramdown::Document.new(content).to_html
    end

    def self.render(content)
      self.to_html(content, :markdown)
    end

    def self.render_gfm(content)
      self.to_html(content, :gfm)
    end
  end
end
