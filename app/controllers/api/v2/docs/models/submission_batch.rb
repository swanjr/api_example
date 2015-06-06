class API::V2::Docs::Models::SubmissionBatch
  include Swagger::Blocks

  swagger_schema :SubmissionBatch do
    key :required, [:allowed_contribution_type]
    property :id do
      key :type, :integer
      key :description, 'Unique identifier for the submission batch'
      key :readOnly, true
    end
    property :name do
      key :type, :string
      key :description, 'User provided submission batch name'
      key :default, "Submission date: #{DateTime.now}"
    end
    property :allowed_contribution_type do
      key :type, :string
      key :description, 'Only this type of contributions can be added to the submission batch'
      key :enum, ::Contribution.types
    end
    property :owner_id do
      key :type, :integer
      key :description, 'Submission batch owners id'
      key :readOnly, true
    end
    property :owner_username do
      key :type, :string
      key :description, 'Submission batch owners username'
      key :readOnly, true
    end
    property :status do
      key :type, :string
      key :description, 'Whether the submission batch is open or closed.'
      key :enum, ::SubmissionBatch.statuses
      key :readOnly, true
    end
    property :created_at do
      key :type, :string
      key :format, 'date-time'
      key :description, 'Datetime submission batch was created'
      key :readOnly, true
    end
    property :updated_at do
      key :type, :string
      key :format, 'date-time'
      key :description, 'Datetime submission batch was last updated'
      key :readOnly, true
    end
  end
  #swagger_schema :SubmissionBatchCreate do
    #allOf do
      #schema do
        #key :'$ref', :SubmissionBatch
      #end
      #schema do
        #key :required, [:name]
        #property :id do
          #key :type, :integer
        #end
      #end
    #end
  #end

end
