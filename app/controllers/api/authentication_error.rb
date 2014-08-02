module API
  class AuthenticationError < API::BaseError
    def initialize(developer_message)
      super(developer_message)
      @http_status_code = 401
      @code = :authentication_failure
    end
  end
end
