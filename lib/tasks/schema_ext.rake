desc "Extend ActiveRecord::Schema to ignore enable_extension for adapter does not support it"
task :schema_ext => :environment do
  class ActiveRecord::Schema
    def enable_extension(*args, &block)
      if connection.respond_to?(:enable_extension)
        connection.enable_extension(*args, &block)
      else
        $stderr.puts "enable_extension is not supported in current database adapter"
      end
    end
  end
end

task 'db:schema:load' => :schema_ext
