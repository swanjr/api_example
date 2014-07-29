require 'active_record_helper'

require 'models/submission_batch'

describe SubmissionBatch do

  describe "validations" do
    it { is_expected.to validate_presence_of(:owner_id) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to ensure_inclusion_of(:media_type)
      .in_array(%w(video)) }
    it { is_expected.to ensure_inclusion_of(:asset_family)
      .in_array(%w(creative editorial)) }
  end

end
