class ExceptionRenderer

  def call(env)
    #Map exceptions for API calls only
    exception = env["action_dispatch.exception"]

    log_exception(exception)

    # Map to API error unless it already is one
    unless exception.kind_of?(API::BaseError)
      exception = convert_exception(exception, env)
    end

    # Render error json
    return [
      exception.http_status_code,
      {'Content-Type' => 'application/vnd.getty.error+json'},
      [exception.to_json]
    ]
  end

  private

  def convert_exception(exception, env)
    # Check if rails can normally handle this exception
    status = ActionDispatch::ExceptionWrapper.new(env, exception).status_code

    if status.present? && status.to_s == '404'
      return API::NotFoundError.new(exception.message)
    elsif status.present? && status.to_s.start_with?('4')
      return API::BadRequestError.new(exception.message, status)
    else
      # Fall back to 500 error
      return API::BaseError.new("An unexpected error occurred.")
    end
  end

  def log_exception(e)
    #msg = { :user_id => nil }
    #Splunk::SplunkLogger.error('api.exception', e) do |payload|
      #payload.merge! msg
    #end
  end
end
