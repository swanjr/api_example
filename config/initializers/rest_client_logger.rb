# Be sure to restart your server when you modify this file.
#
# RestClient logs using << which isn't supported by the Rails logger,
# so wrap it up with a little proxy object.
RestClient.log = Object.new.tap do |proxy|
  def proxy.<<(message)
    Rails.logger.debug message
  end
end
