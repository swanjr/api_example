class BaseError < StandardError
  attr_reader :http_status_code, :code, :message, :occurred_at

  def initialize(developer_message, http_status_code = 500, code = :internal_server_error)
    @message = developer_message
    @occurred_at = Time.now
    @http_status_code = http_status_code
    @code = code
  end
end
