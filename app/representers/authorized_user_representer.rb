module AuthorizedUserRepresenter
  include Representable::JSON

  property :id
  property :account_id
  property :username
  property :token, getter: lambda { |*| token.value if token }
  property :expires_at, getter: lambda { |*| token.expires_at if token }
end
