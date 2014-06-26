module API
  class ValidationError < BaseError
    attr_reader :messages

    def initialize(developer_message)
      super(developer_message)
      @http_status_code = 422
      @code = :validation_error
      @messages = []
    end

    def add_message(resource, field_name, message)
      @messages << FieldError.new(resource, field, message)
    end

    def add_model_messages(model)
      resource = model.class.to_s
      model.errors.each do |field, message|
        @messages << FieldError.new(resource, field, message)
      end
    end

    class FieldError
      attr_accessor :resource, :field, :message

      def initialize(resource, field, message)
        @resource = resource
        @field = field
        @message = message
      end
    end
  end
end
