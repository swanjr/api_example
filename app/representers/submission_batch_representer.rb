module SubmissionBatchRepresenter
  include Representable::JSON

  property :id
  property :owner_id,
    reader: lambda {|val, args| self.owner_id = args[:owner_id] }
  property :name
  property :media_type
  property :asset_family
  property :istock
  property :status
  property :created_at
end
