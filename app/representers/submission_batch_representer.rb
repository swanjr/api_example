module SubmissionBatchRepresenter
  include Representable::JSON

  property :id

  property :owner_id,
    writeable: false

  property :owner_username,
    if: :owner_username_exists?,
    writeable: false,
    getter: :owner_username

  property :name

  property :allowed_contribution_type,
    skip_parse: lambda { |fragment, options| allowed_contribution_type.present? }

  property :status,
    writeable: false

  property :event_id

  property :brief_id

  property :assignment_id

  property :apply_extracted_metadata,
    skip_parse: lambda { |fragment, options| contributions.empty? }

  property :created_at,
    writeable: false

  property :updated_at,
    writeable: false

  private

  def field_exists?(field)
    respond_to?(field)
  end

  def owner_username_exists?(args)
    respond_to?(:owner) && owner.respond_to?(:username)
  end

  def owner_username(args)
    return nil unless owner
    owner.username
  end

end
