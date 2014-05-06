module Getty
  module Instrumentation
    class Scrubber
      def self.scrub_hash(hash)
        result = {}
        hash.each do |k,v|
          if v.is_a?(Hash)
            result[k] = scrub_hash(v)
          else
            if v.is_a?(String) || v.is_a?(Integer)
              result[k] = scrubbed_value(k, v.to_s)
            else
              result[k] = v
            end
          end
        end
        result
      end

      private

      def self.scrubbed_value(key, value)
        if value.nil? or value.to_s.empty?
          return ''
        end
        if key.to_s.downcase.include?('password')
          return '**********'
        end
        if key.to_s.downcase.include?('token')
          return "#{value[0,7]}*******************"
        end
        if key.to_s.downcase.include?('card') && key.to_s.downcase.include?('number')
          return '*' * (value.length - 4) + value[-4,4]
        end
        if key.to_s.downcase.include?('cvv')
          return '*' * value.length
        end
        return value
      end

    end
  end
end

