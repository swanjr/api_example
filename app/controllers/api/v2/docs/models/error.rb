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
    end
    property :occurred_at do
      key :type, :string
      key :description, 'The date and time the error occurred at.'
      key :format, 'date-time'
    end
    property :code do
      key :type, :string
      key :description, 'A system defined status code that may be more specific than the HTTP status code'
    end
  end

  swagger_schema :NotFoundError do
    allOf do
      schema do
        key :'$ref', :Error
      end
      schema do
        property :http_status_code do
          key :default, 404
        end
        property :code do
          key :default, 'not_found'
        end
      end
    end
  end

  swagger_schema :UnexpectedError do
    allOf do
      schema do
        key :'$ref', :Error
      end
      schema do
        property :http_status_code do
          key :default, 500
        end
        property :code do
          key :default, 'internal_server_error'
        end
      end
    end
  end

end
