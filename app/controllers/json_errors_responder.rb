class JSONErrorsResponder < ActionController::Responder

  protected

  def json_resource_errors
    error = ValidationError.new("The request to [#{request.original_url}] failed with validation errors.")
    error.add_model_messages(resource)

    raise error
  end
end
