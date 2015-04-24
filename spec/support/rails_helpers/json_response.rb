# Example configuration in rails_helper.rb
#
# config.include JSON::Response, type: :request
#
# A type of :request means this will only be run for request specs or
# when the entire suite is run.
module JSON
  module Response
    def json
      @json ||= JSON.parse(response.body)
    end
  end
end
