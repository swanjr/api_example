module Context
  class AuthenticateUser

    def self.authenticate(username, password)
      AuthenticateUser.new(username, password).authorized_user
    end

    def initialize(username, password)
      @username = username
      @token = Security::GettyToken.create(username, password)
    end

    def authorized_user
      return nil unless @token
      find_authorized_user
    end

    private

    def find_authorized_user
      authorized_user = AuthorizedUser.find_by_account_id(@token.account_id)

      if authorized_user
        #Set token and sync username
        if authorized_user
          authorized_user.token = @token
          authorized_user.sync_username(@username)
        end
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
