ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)

require 'active_record_helper'

require 'rspec/rails'
require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

# Include rails specific helpers
Dir[Rails.root.join("spec/support/rails_helpers/*.rb")].each { |f| require f }

RSpec.configure do |config|

  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
  end

  # Always run request specs first so non-request spec changes to class configurations
  # don't override out global test environment class configurations. Request specs and non-request
  # specs are still randomized in their own group.
  config.register_ordering(:global) do |items|
    items.sort_by do |group|
      case group.metadata[:type]
      when :request then rand(1..25)
      else rand(26..50)
      end
    end
  end

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Add rails specific spec helpers
  config.include Webmock::Isolation, type: :request
  config.include ShowErrors, type: :request
  config.include Authentication, type: :request
  config.include Authorization, type: :request
  config.include JSON::Response, type: :request
  config.include Rack::Matchers, type: :request
end
