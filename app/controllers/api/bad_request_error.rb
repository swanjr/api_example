class API::BadRequestError < API::BaseError
  def initialize(developer_message, status = 400)
    super(developer_message, status)
    @code = :bad_request
  end
end
