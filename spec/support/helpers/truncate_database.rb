# Enabled for all specs.
require 'database_cleaner'

module TruncateDatabase
  RSpec.configure do |config|

    #Truncate the database before running the specs if TRUNCATE is enabled.
    config.before(:suite) do |example|
      if ENV['TRUNCATE'] == 'true'
        DatabaseCleaner.clean_with(:truncation)
      end
    end
  end
end
