class API::NotFoundError < API::BadRequestError
  def initialize(developer_message, code = :not_found)
    super(developer_message, 404)
    @code = code
  end
end
