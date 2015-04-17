module API
  class AuthenticationError < API::BadRequestError
    def initialize(developer_message, code = :authentication_failure)
      super(developer_message, 401)
      @code = code
    end
  end
end
