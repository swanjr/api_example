class Role::AuthorizedUser < User
  attr_accessor :token

  def check_username(authorized_username)
    if self.username != authorized_username
      self.username = authorized_username
      save!
    end
  end
end
