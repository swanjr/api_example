class API::V2::Docs::SubmissionBatchAPI::Index
  include Swagger::Blocks

  swagger_path '/v2/submission_batches' do
    operation :get do
      key :operationId, 'search_submission_batches'
      key :description, 'Searches for submission batches matching the provided search criteria.'
      key :tags, [
        'Submission Batch API V2'
      ]
      parameter do
        key :name, :fields
        key :type, :array
        key :description, 'The data fields to return. All fields are return if not specified.'
        key :in, :query
        key :required, false
        items do
          key :type, :string
          key :enum, [:id, :name, :allowed_contribution_type, :owner_id,
                      :owner_usernname, :status, :created_at, :updated_at]
        end
      end
      parameter do
        key :name, :filters
        key :type, :array
        key :description, %q(The data filters that should be applied to the search. A filter 
        consists of a field name, an operator, and a value(s). Valid operators are: 
        <=, >=, !=, =, >, <. The search also supports wild cards (name=* Doe) and
        value lists (name=[John, Jake]).).delete("\n")
        key :in, :query
        key :required, false
        items do
          key :type, :string
        end
      end
      parameter do
        key :name, :sort
        key :type, :array
        key :description, %q(The fields to sort by and their sort direction.
        For ascending, enter just the field name or (if desired) add a + in front of the name.
        For descending, add a - in front of the field name.).delete("\n")
        key :in, :query
        key :required, false
        key :default, 'id'
        items do
          key :type, :string
        end
      end
      parameter do
        key :name, :offset
        key :type, :integer
        key :description, 'Number of items skipped before starting to return items.'
        key :in, :query
        key :required, false
      end
      parameter do
        key :name, :limit
        key :type, :integer
        key :description, 'Number of results to return'
        key :in, :query
        key :required, false
        key :default, ::Queries::SubmissionBatchSearch.default_limit
        key :maximum, ::Queries::SubmissionBatchSearch.max_limit
      end
      response 200 do
        key :description, 'Search results'
        schema do
          allOf do
            schema do
              property :items do
                key :type, :array
                items do
                  key :type, :object
                  key :'$ref', :SubmissionBatch
                end
              end
            end
            schema do
              key :'$ref', :SearchMetadata
            end
          end
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
