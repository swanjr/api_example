require 'active_record_helper'

require 'models/user'
require 'models/contribution'

require 'models/submission_batch'

describe SubmissionBatch do

  describe "associations" do
    it { is_expected.to belong_to(:owner) }
    it { is_expected.to have_many(:contributions) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:owner_id) }
    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to validate_inclusion_of(:allowed_contribution_type).
         in_array(Contribution.types) }
    it { is_expected.to validate_inclusion_of(:status).
         in_array(SubmissionBatch.statuses) }
  end

end
