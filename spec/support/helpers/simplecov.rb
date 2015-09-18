# Enabled for all specs.
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
