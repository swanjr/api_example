module Context
  class AuthenticateUser

    # Returns nil if authentication fails
    def self.authenticate(username, password)
      token = Security::GettyToken.create(username, password)
      authorized_user = AuthenticateUser.new(token).authorized_user

      authorized_user.sync_username(username) if authorized_user
      authorized_user
    end

    # Returns nil if authentication fails
    def self.authenticate_token(token)
      return nil if token.nil?

      token = Security::GettyToken.new(token)
      AuthenticateUser.new(token).authorized_user if token.valid?
    end

    def initialize(token)
      @token = token
    end

    def authorized_user
      return nil unless @token
      find_authorized_user
    end

    private

    def find_authorized_user
      authorized_user = AuthorizedUser.find_by_account_id(@token.account_id)

      if authorized_user
        authorized_user.token = @token
      else
        raise Esp::UnknownUserError.new("User #{@username} has not been added to the database.")
      end
      authorized_user
    end

    class AuthorizedUser < User
      attr_accessor :token

      # Override database username if it doesn't match parameter
      def sync_username(authorized_username)
        if authorized_username.present? && self.username != authorized_username
          self.username = authorized_username
          save!
        end
      end
    end

  end
end
