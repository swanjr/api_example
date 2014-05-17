module Security
  class BaseToken
    attr_reader :account_id, :key, :duration

    def valid?
      false
    end
  end

  class TokenError < StandardError
  end
end
