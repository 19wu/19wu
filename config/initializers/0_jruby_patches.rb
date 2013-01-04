# Should load early to handle jruby compatible issues

if RUBY_PLATFORM == 'java'
  $:.unshift Rails.root.join('lib', 'jruby_patches')
end
