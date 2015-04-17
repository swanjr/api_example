class API::UnprocessableEntityError < API::BadRequestError
  def initialize(developer_message, code = :unprocessable_entity)
    super(developer_message, 422)
    @code = code
  end
end
