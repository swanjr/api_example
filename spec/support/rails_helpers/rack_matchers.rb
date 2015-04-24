# Example configuration in rails_helper.rb
#
# config.include Rack::Matchers, type: :request
#
# A type of :request means this will only be run for request specs or
# when the entire suite is run.
module Rack
  module Matchers
    def have_status(status)
      HaveRackStatusMatcher.new(status)
    end

    class HaveRackStatusMatcher
      def initialize(status)
        @status = status
      end

      def matches?(subject)
        @actual_status = subject.status
        return @actual_status == Rack::Utils.status_code(@status)
      end

      def failure_message
        "expected #{Rack::Utils.status_code(@status)} but got #{@actual_status}"
      end

      def failure_message_when_negated
        "did not expect response to be #{@actual_status}.  expected #{Rack::Utils.status_code(@status)}"
      end
    end
  end
end
