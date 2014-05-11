class Context::AuthenticateUser

  def self.authenticate(username, password)
    authorized_user = nil

    token = Security::GettyToken.create(username, password)

    if token.present?
      authorized_user = Role::AuthorizedUser.find_by(account_id: token.account_id)
      if authorized_user.present?
        authorized_user.token = token

        # Make sure account username matches the authorized username
        authorized_user.override_username(username)
      else
        raise Esp::UnknownUserError.new("User #{username} has not been added to the database.")
      end
    end

    authorized_user
  end
end
