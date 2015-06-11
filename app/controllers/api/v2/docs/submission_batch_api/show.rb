class API::V2::Docs::SubmissionBatchAPI::Show
  include Swagger::Blocks

  swagger_path '/v2/submission_batches/{id}' do
    operation :get do
      key :operationId, 'get_submission_batch'
      key :description, 'Returns the submission batch associated with the provided id.'
      key :tags, [
        'Submission Batch API V2'
      ]
      parameter do
        key :name, :id
        key :type, :integer
        key :description, "Unique id for the submission batch."
        key :in, :path
        key :required, true
      end
      response 200 do
        key :description, 'The submission batch.'
        schema do
          key :'$ref', :SubmissionBatch
        end
      end
      response 404 do
        key :description, 'No submission batch could be found for the provided id.'
        schema do
          key :'$ref', :NotFoundError
        end
      end
      response :default do
        key :description, 'Unexpected error'
        schema do
          key :'$ref', :UnexpectedError
        end
      end
    end
  end
end
