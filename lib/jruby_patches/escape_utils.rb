require 'cgi'
require 'uri'

module EscapeUtils
  extend self

  def escape_html(html)
    CGI.escapeHTML(html)
  end

  def escape_uri(uri)
    URI.escape(uri)
  end
end
