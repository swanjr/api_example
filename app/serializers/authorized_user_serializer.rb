class AuthorizedUserSerializer < ActiveModel::Serializer
  attributes :id, :account_id, :username, :token, :expires_at

  def token
    object.token.value if object.token
  end

  def expires_at
    object.token.expires_at if object.token
  end
end
