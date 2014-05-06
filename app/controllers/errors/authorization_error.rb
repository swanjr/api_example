class AuthorizationError < BaseError
  def initialize(developer_message)
    super(developer_message)
    @http_status_code = 403
    @code = :unauthorized
  end
end
