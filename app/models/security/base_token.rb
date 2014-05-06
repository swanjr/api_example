module Security
  class BaseToken
    attr_reader :account_id, :key, :duration

    def self.create
      raise "Override to create token"
    end

    def valid?
      false
    end
  end

  class TokenError < StandardError
  end
end
