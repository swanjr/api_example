class AuthorizedUserSerializer < ActiveModel::Serializer
  attributes :id, :account_id, :username, :token, :duration

  def token
    object.token.key if object.token.present?
  end

  def duration
    object.token.duration if object.token.present?
  end
end
