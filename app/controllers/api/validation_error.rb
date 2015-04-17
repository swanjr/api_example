module API
  class ValidationError < API::UnprocessableEntityError
    attr_reader :messages

    def initialize(developer_message = "Failed with validation errors.", code = :validation_error)
      super(developer_message, code)
      @messages = []
    end

    def add_message(resource, field_name, message)
      @messages << FieldError.new(resource, field, message)
      self
    end

    def add_model_messages(model)
      resource = model.class.to_s
      model.errors.each do |field, message|
        @messages << FieldError.new(resource, field, message)
      end
      self
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
