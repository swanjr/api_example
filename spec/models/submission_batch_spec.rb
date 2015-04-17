require 'active_record_helper'

require 'models/submission_batch'

describe SubmissionBatch do

  describe "validations" do
    it { is_expected.to validate_presence_of(:owner_id) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:allowed_contribution_type) }
    it { is_expected.to validate_presence_of(:status) }
  end

end
