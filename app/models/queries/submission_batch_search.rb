module Queries
  class SubmissionBatchSearch < DynamicSearch

    def initialize(limit = nil)
      super(SubmissionBatch.joins(:owner), limit)
    end

    protected

    def process_fields(fields)
      fields << 'owner_id' if fields.to_s.include?('owner_username')
      super(fields)
    end

    def qualify_field(field_name)
      return 'users.username' if is_owner_username?(field_name)
      super
    end

    def valid_field?(field_name)
      is_owner_username?(field_name) || super
    end

    private

    def is_owner_username?(field_name)
      field_name.to_s.downcase == 'owner_username'
    end
  end
end
