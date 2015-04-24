module SubmissionBatchRepresenter
  include Representable::JSON

  property :id
  property :owner_id,
    setter: lambda { |val, args| self.owner_id = args[:owner_id] },
    skip_parse: lambda { |fragment, options| self.owner_id.present? }
  property :owner_username,
    writeable: false,
    getter: lambda { |*| user.username }
  property :name
  property :allowed_contribution_type,
    skip_parse: lambda { |fragment, options| self.allowed_contribution_type.present? }
  property :status, writeable: false
  property :created_at, writeable: false
  property :updated_at, writeable: false
end
