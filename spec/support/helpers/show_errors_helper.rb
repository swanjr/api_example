# Example configuration in rails_helper.rb
#
# config.include ShowErrors, type: :request
#
# A type of :request means this will only be run for request specs or 
# when the entire suite is run.
module ShowErrorsHelper

  RSpec.configure do |config|
    #Disable application global error handler and show errors in rspecs if SHOW_ERRORS is enabled.
    config.before(:suite) do |example|
      if ENV['SHOW_ERRORS'] == 'true'
        Rails.application.config.action_dispatch.show_exceptions = false
      end
    end
  end
end
