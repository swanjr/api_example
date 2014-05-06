module Getty
  module Instrumentation
    class LogEvent
      def initialize(event_name, date_time = nil, payload = {})
        @log_data = {
          event_name: event_name,
          date_time: (date_time || Time.now).utc.strftime("%Y-%m-%d %H:%M:%S.%3NZ")
        }
        @log_data.merge! payload
        logger_info = Thread.current[:logger_info]
        @log_data[:context] = logger_info if logger_info
      end
      def add_data(data)
        @log_data.merge!(data)
      end
      def log_data
        Getty::Instrumentation::Scrubber.scrub_hash(@log_data)
      end
    end
  end
end
