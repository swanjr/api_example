module Configurable
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def config
      @config ||= Configuration.new
    end

    def config=(config)
      @config = config
    end

    def configure
      self.config ||= Configuration.new
      yield(config)
    end

  end

  class Configuration
    @@options = {}

    def respond_to?(name, include_private = false)
      super || @@options.key?(name.to_sym)
    end

    def to_hash
      @@options.clone
    end

    def from_hash(config)
      @@options = config
    end

    private

    def method_missing(name, *args, &blk)
      if name.to_s =~ /=$/
        @@options[$`.to_sym] = args[0]
      elsif @@options.key?(name)
        @@options[name]
      else
        super
      end
    end
  end

end
