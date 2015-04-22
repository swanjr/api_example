# Example configuration in rails_helper.rb
#
# config.include Response::JsonHelper, type: :request
#
# A type of :request means this will only be run for request specs or
# when the entire suite is run.
module Response
  module JsonHelper
    def json
      @json ||= JSON.parse(response.body)
    end
  end
end
