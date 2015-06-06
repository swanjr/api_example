class API::V2::Docs::Models::Error
  include Swagger::Blocks

  swagger_schema :Error do
    key :required, [:message, :http_status_code, :occurred_at, :code]
    property :message do
      key :type, :string
      key :description, 'Descriptive error message'
    end
    property :http_status_code do
      key :type, :integer
      key :description, 'The HTTP status code defined by the HTTP protocol'
      key :default, 500
    end
    property :occurred_at do
      key :type, :string
      key :description, 'The date and time the error occurred at.'
      key :format, 'date-time'
    end
    property :code do
      key :type, :string
      key :description, 'A system defined status code that may be more specific than the HTTP status code'
      key :default, 'internal_server_error'
    end
  end
end
