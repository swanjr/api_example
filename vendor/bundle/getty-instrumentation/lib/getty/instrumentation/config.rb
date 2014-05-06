module Getty
  module Instrumentation
    def self.config
      @config ||= Config.new
    end

    class Config
      attr_accessor :swallow_non_critical_exceptions
    end
  end
end

