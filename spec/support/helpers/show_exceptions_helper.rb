module ShowExceptionsHelper
  # Disable global error handling to see actual error message.
  def disable_show_exceptions
    Rails.application.config.action_dispatch.show_exceptions = false
  end
end
