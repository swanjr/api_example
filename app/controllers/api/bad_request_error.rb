class API::BadRequestError < API::BaseError
  def initialize(developer_message, status = 400)
    super(developer_message)
    @http_status_code = status
    @code = :bad_request
  end
end
