class AuthenticationError < BaseError
  def initialize(developer_message)
    super(developer_message)
    @http_status_code = 401
    @code = :invalid_credentials
  end
end
