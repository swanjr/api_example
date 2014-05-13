ENV["RAILS_ENV"] ||= 'test'

require 'active_support/core_ext'
require 'active_record'
require 'yaml'

# Load connection info
connection_info = YAML.load_file("config/database.yml")["test"]
ActiveRecord::Base.establish_connection(connection_info)

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # Disable old 'should' systax 
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Disable database connections except for the :db metadata tag
  config.around(:each) do |example|
    unless example.metadata[:db]
      class << ActiveRecord::Base.connection
        define_method(:exec, proc { raise "Database connection disabled in unit tests." })
        define_method(:exec_query, proc { raise "Database connection disabled in unit tests." })
      end
    end

    # Add transactions manually
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end
