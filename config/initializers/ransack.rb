Ransack.configure do |config|
  config.add_predicate 'gteq_price', # Name your predicate
                       # What non-compound ARel predicate will it use? (eq, matches, etc)
                       :arel_predicate => 'gteq',
                       # Format incoming values as you see fit. (Default: Don't do formatting)
                       :formatter => proc {|v| (v.to_f * 100).to_i },
                       # Validate a value. An "invalid" value won't be used in a search.
                       # Below is default.
                       :validator => proc {|v| v.present?},
                       # Should compounds be created? Will use the compound (any/all) version
                       # of the arel_predicate to create a corresponding any/all version of
                       # your predicate. (Default: true)
                       :compounds => false,
                       # Force a specific column type for type-casting of supplied values.
                       # (Default: use type from DB column)
                       :type => :float    # change to float
end
