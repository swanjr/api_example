module API
  class BaseError < StandardError
    attr_reader :http_status_code, :code, :message, :occurred_at

    def initialize(developer_message, status = 500)
      @message = developer_message
      @occurred_at = DateTime.now
      @http_status_code = status
      @code = :internal_server_error
    end
  end
end
