module SubmissionBatchRepresenter
  include Representable::JSON

  property :id

  property :owner_id,
    if: lambda { |args| field_exists?(:owner_id) },
    writeable: false

  property :owner_username,
    if: :owner_username_exists?,
    writeable: false,
    getter: :owner_username

  property :name,
   if: lambda { |args| field_exists?(:name) }

  property :allowed_contribution_type,
    if: lambda { |args| field_exists?(:name) },
    skip_parse: lambda { |fragment, options| allowed_contribution_type.present? }

  property :status,
    if: lambda { |args| field_exists?(:status) },
    writeable: false

  property :created_at,
    if: lambda { |args| field_exists?(:created_at) },
    writeable: false

  property :updated_at,
    if: lambda { |args| field_exists?(:updated_at) },
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
