module Security
  class BaseToken
    attr_reader :account_id, :value, :expires_at

    def valid?
      false
    end
  end

  class TokenError < StandardError
  end
end
