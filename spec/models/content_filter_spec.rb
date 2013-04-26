# encoding: utf-8
require 'spec_helper'

describe ContentFilter do
  
  context 'markdown content' do
    
    it 'has headers' do
      (1..3).each do |num|
        result = ContentFilter.refine("#"*num+" test")
        result.should == "<h"+num.to_s+">test</h"+num.to_s+">"
      end
    end

    it 'has italic words' do
      ContentFilter.refine("*test*").should == "<p><em>test</em></p>"
    end

    it 'has bold words' do
      ContentFilter.refine("**test**").should == "<p><strong>test</strong></p>"
    end

    it 'has unordered lists' do
      input = "* test1\n* test2\n * test2a\n * test2b"
      expected = "<ul>\n<li>test1</li>\n<li>test2\n\n<ul>\n<li>test2a</li>\n<li>test2b</li>\n</ul>\n</li>\n</ul>"
      ContentFilter.refine(input).should == expected
    end

    it 'has ordered lists' do
      input = "1. test1\n2. test2\n * test2a\n * test2b"
      expected = "<ol>\n<li>test1</li>\n<li>test2\n\n<ul>\n<li>test2a</li>\n<li>test2b</li>\n</ul>\n</li>\n</ol>"
      ContentFilter.refine(input).should == expected
    end

    it 'has an image' do
      input = "![19wu Logo](/images/logo.png)"
      expected = %&<p><img src="/images/logo.png" alt="19wu Logo"></p>&
      ContentFilter.refine(input).should == expected
    end

    it 'has a link' do
      input = "http://19wu.com"
      expected = %&<p><a href="http://19wu.com">http://19wu.com</a></p>&
      ContentFilter.refine(input).should == expected
    end

    it 'has a blockqoutes' do
      input = "> welcome to 19wu"
      expected = "<blockquote>\n<p>welcome to 19wu</p>\n</blockquote>"
    end

    it 'has a pre code' do
      input = <<-EOF
```
第一行无空格
  第二行前面两个空格也会保留
```
EOF
      expected = "<pre><code>第一行无空格\n  第二行前面两个空格也会保留\n</code></pre>"
      ContentFilter.refine(input).should == expected
    end
  
  end

end
