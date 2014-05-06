require 'getty/instrumentation/json_logger'
require 'getty/instrumentation/log_event'

module Getty
  module Instrumentation
    def self.initialize
      JSONLogger.initialize_logger
      initializer = Initializer.new(config)
      yield initializer
      initializer
    end

    class Initializer

      def initialize(config)
        @config = config
      end

      def subscribe_and_log(event_name, options = {})
        log_as = options[:log_as] || event_name
        ActiveSupport::Notifications.subscribe(event_name) do |*args|
          notification_event = ActiveSupport::Notifications::Event.new(*args)
          unless options[:unless] && options[:unless].call(notification_event)
            log_event = construct_log_event(log_as, notification_event, options)
            JSONLogger.log log_event
            raise_exception_if_necessary(notification_event, options)
          end
        end
      end


      private

      def raise_exception_if_necessary(notification_event, options)
        if options[:raise_as_non_critical]
          unless @config.swallow_non_critical_exceptions
            raise notification_event.payload[:exception]
          end
        end
      end

      def construct_log_event(event_name, notification_event, options)
        log_event = Getty::Instrumentation::LogEvent.new(event_name, notification_event.time)
        log_event.add_data(notification_event.payload)
        if options[:capture_duration]
          log_event.add_data(duration_in_ms: notification_event.duration.to_i)
        end
        log_event
      end
    end
  end
end