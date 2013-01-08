# A sample Guardfile
# More info at https://github.com/guard/guard#readme

group :web do

  guard 'rails' do
    watch('Gemfile.lock')
    watch(%r{^(config|lib)/.*})
  end

end

group :worker do

  guard 'delayed', :environment => 'development' do
    watch(%r{^app/(.+)\.rb})
  end

end

group :frontend do

  guard 'livereload' do
    watch(%r{app/views/.+\.(erb|haml|slim)$})
    watch(%r{app/helpers/.+\.rb})
    watch(%r{public/.+\.(css|js|html)})
    watch(%r{config/locales/.+\.yml})
    # Rails Assets Pipeline
    watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|js|html))).*}) { |m| "/assets/#{m[3]}" }
  end

end

#group :backend do
#end
