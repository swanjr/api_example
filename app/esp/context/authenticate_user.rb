module Context
  class AuthenticateUser

    def self.authenticate(username, password)
      authorized_user = nil

      token = Security::GettyToken.create(username, password)

      if token
        authorized_user = AuthorizedUser.find_by_account_id(token.account_id)
        if authorized_user.present?
          authorized_user.token = token

          authorized_user.sync_username(username)
        else
          raise Esp::UnknownUserError.new("User #{username} has not been added to the database.")
        end
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
