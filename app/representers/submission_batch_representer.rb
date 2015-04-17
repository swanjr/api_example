module SubmissionBatchRepresenter
  include Representable::JSON

  property :id
  property :owner_id,
    reader: lambda {|val, args| self.owner_id = args[:owner_id] }
  property :name
  property :allowed_contribution_type, if: lambda { |args| self.allowed_contribution_type.nil? }
  property :status, writeable: false
  property :created_at, writable: false
  property :updated_at, writable: false
end
