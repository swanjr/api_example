class ApidocsController < ActionController::Base
  include Swagger::Blocks

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, 'v2'
      key :title, 'ESP API'
    end
    tags do
      key :name, 'Submission Batch API V2'
      key :description, %q(A submission batch is a container owned by a user to group together 
      related contributions and releases.).delete("\n")
    end
    key :basePath, '/api'
    key :consumes, ['application/json']
    key :produces, ['application/json']
    key :schemes, [Rails.env.development? || Rails.env.test? ? 'http' : 'https']
  end

  # A list of all classes that have swagger_* declarations.
  SWAGGERED_CLASSES = [
    API::V2::Docs::Models::Error,
    API::V2::Docs::Models::SearchMetadata,
    API::V2::Docs::Models::SubmissionBatch,
    API::V2::Docs::SubmissionBatchAPI::Index,
    self
  ].freeze
  def index
    render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
  end
end
