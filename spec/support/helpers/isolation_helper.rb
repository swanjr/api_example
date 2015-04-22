# Example configuration in rails_helper.rb
#
# config.include Webmock::IsolationHelper, type: :request
#
# A type of :request means this will only be run for request specs or
# when the entire suite is run.
#
# This module is setup to allow request specs to use external dependencies
# unless isolation is enabled. Set environment variable ISOLATE to true to
# enable isolation mode.
module Webmock
  module IsolationHelper

    RSpec.configure do |config|
      config.before do |example|
        @isolate = ENV['ISOLATE'] == 'true'

        if example.metadata[:type] == :request && !@isolate
          WebMock.allow_net_connect!
        end
      end
    end

    def isolate
      @isolate
    end

    # Mock service call if request spec isolation is enabled. Verifies the call was made.
    def stub_for_isolation(method, url, response_body = '', status = :ok, response_headers = {})
      if isolate
        response_hash = {
          body: response_body,
          status: status,
          headers: response_headers
        }
        WebMock.stub_request(method, url).to_return(response_hash)
      end
    end
  end
end
