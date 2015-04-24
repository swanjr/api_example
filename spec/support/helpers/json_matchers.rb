# Example configuration in spec_helper.rb
#
# config.include JSON::Matchers
#
# A type of :request means this will only be run for request specs or
# when the entire suite is run.
module JSON
  module Matchers
    def eq_json(status)
      MatchJSONMatcher.new(status)
    end

    class MatchJSONMatcher
      def initialize(expected = nil)
        @expected_json = normalize(expected)
      end

      def matches?(actual)
        @actual_json = normalize(actual)
        return @actual_json == @expected_json
      end

      def failure_message
        "expected #{@expected_json} but got #{@actual_json}"
      end

      def failure_message_when_negated
        "did not expect json to be #{@actual_json}, expected #{@expected_json}"
      end

      private

      def normalize(object)
        if object.class != String
          # Convert to json if it is not already json so it can be parsed.
          object = object.to_json
        end

        # To normalize data it must be parsed.
        object = JSON.parse(object)

        case object
        when Hash, Array then JSON.pretty_generate(object)
        else object.to_json
        end
      end
    end
  end
end
