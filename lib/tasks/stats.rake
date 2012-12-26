desc "Add files that DHH doesn't consider to be 'code' to stats"
task :stats_setup do
  require 'rails/code_statistics'

  class CodeStatistics
    alias calculate_statistics_orig calculate_statistics
    def calculate_statistics
      @pairs.inject({}) do |stats, pair|
        if 3 == pair.size
          stats[pair.first] = calculate_directory_statistics(pair[1], pair[2]); stats
        else
          stats[pair.first] = calculate_directory_statistics(pair.last); stats
        end
      end
    end
  end
  ::STATS_DIRECTORIES << ['Views',  'app/views', /\.(rhtml|erb|rb|slim|jbuilder)$/]
  ::STATS_DIRECTORIES << ['JS',  'app/assets/javascripts', /\.(js|coffee)$/]
  ::STATS_DIRECTORIES << ['CSS',  'app/assets/stylesheets', /\.(css|sass|scss)$/]

  ::STATS_DIRECTORIES << ['JS Test',  'spec/javascripts', /\.(js|coffee)$/]
  ::CodeStatistics::TEST_TYPES << 'JS Test'
end
task :stats => :stats_setup
