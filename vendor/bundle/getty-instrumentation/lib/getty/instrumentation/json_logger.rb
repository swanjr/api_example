module Getty
  module Instrumentation
    class JSONLogger

      def self.initialize_logger

        if @unisporkal_logger.nil?
          logfile = File.open(Rails.root.join("log/esp_#{Rails.env}.log"), 'a')
          logfile.sync = true
          @unisporkal_logger = Logger.new(logfile)
          @unisporkal_logger.datetime_format = '%Y-%m-%d %H:%M:%S'
          @unisporkal_logger.formatter = proc do |severity, datetime, progname, msg|
            "#{datetime}: #{msg}\n"
          end
        end

        @unisporkal_logger
      end

      def self.log(log_event)
        data = log_event.log_data.to_json
        @unisporkal_logger.info data
      end

      def self.log_unhandled_exception(exception, reference_id)
        log_event = Getty::Instrumentation::LogEvent.new("exception.unhandled")
        log_event.add_data({
                               reference_id: reference_id,
                               message: exception.message,
                               short_stack_trace: truncated_stack_trace(exception),
                               details:{
                                   stack_trace: exception.backtrace
                               }
                           })
        @unisporkal_logger.error log_event.log_data.to_json
      end

      def self.truncated_stack_trace(exception)
        begin
          exception.backtrace.select{ |trace_line| !(trace_line =~ /\/vendor\/cache\// || trace_line =~ /\/\.rvm\/gems\//)}
        rescue
          ['error - unable to create the short stack trace']
        end
      end
    end
  end
end
