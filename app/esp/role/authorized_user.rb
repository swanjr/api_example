class Role::AuthorizedUser < User
  attr_accessor :token

  # Override database username if it doesn't match parameter
  def override_username(authorized_username)
    if authorized_username.present? && self.username != authorized_username
      self.username = authorized_username
      save!
    end
  end
end
