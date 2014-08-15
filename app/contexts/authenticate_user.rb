class AuthenticateUser

  # Returns nil if authentication fails
  def self.authenticate_token(token_value)
    credentials = TokenCredentials.new(token_value)
    AuthenticateUser.new(credentials).authorized_user
  end

  def initialize(credentials)
    @credentials = credentials
  end

  def authorized_user
    AuthorizedUser.create(@credentials)
  end


  ## Role Classes ##
  class AuthorizedUser < User
    attr_accessor :token

    def self.create(credentials)
      token = credentials.authenticate
      self.find_by_token(token)
    end

    private

    def self.find_by_token(token)
      return nil unless token
      authorized_user = nil

      if token.valid?
        authorized_user = self.find_by_account_id(token.account_id)
        unless authorized_user
          raise UnknownUserError.new("User with account id #{token.account_id} was not found in the database.")
        end
        authorized_user.token = token
      end
      authorized_user
    end

  end

  class TokenCredentials
    def initialize(token_value)
      @token_value = token_value
    end

    def authenticate
      return nil unless @token_value

      token = Security::GettyToken.new(@token_value)
      if token.expired?
        raise ExpiredTokenError.new("User token has expired.")
      end
      token
    end
  end
end

## Error classes ##
class ExpiredTokenError < StandardError
end

class UnknownUserError < StandardError
end
