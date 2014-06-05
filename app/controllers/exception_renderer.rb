class ExceptionRenderer
  include Configurable

  def call(env)
    exception = env["action_dispatch.exception"]

    unless exception.kind_of?(BaseError)
      exception = map_exception(exception, env)
    end

    [exception.http_status_code, {'Content-Type' => 'application/json'}, [exception.to_json]]
  end

  private

  def map_exception(exception, env)
    mapped_exception = lookup_mapping(exception)

    if mapped_exception.nil?
      # Check if rails can normally handle this exception
      status = ActionDispatch::ExceptionWrapper.new(env, exception).status_code
      if status.present? && status != 500
        mapped_exception = BaseError.new(exception.message, status, :client_error)
      else
        # Fall back to 500 error
        mapped_exception = BaseError.new("Internal server error")
      end
    end
    mapped_exception
  end

  def lookup_mapping(exception)
    self.class.config.error_mappings[exception.class.to_s]
  end
end
