# Example configuration in rails_helper.rb
#
# config.include Simplecov, type: :request
#
# A type of :request means this will only be run for request specs or 
# when the entire suite is run.
module Simplecov

  RSpec.configure do |config|
    #Enable simplecov for run when SIMPLECOV is enabled.
    config.before(:suite) do |example|
      if ENV['SIMPLECOV'] == 'true'
        require 'simplecov'
        SimpleCov.start
      end
    end
  end
end
