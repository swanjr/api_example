require 'active_record_helper'

require 'models/submission_batch'

describe SubmissionBatch do

  describe "validations" do
    it { is_expected.to validate_presence_of(:owner_id) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_inclusion_of(:media_type)
      .in_array(%w(video)) }
    it { is_expected.to validate_inclusion_of(:asset_family)
      .in_array(%w(creative editorial)) }
  end

  describe 'auditing', versioning: true do
    let(:submission) { SubmissionBatch.create(name: 'Submission',
                                              owner_id:1,
                                              media_type: 'video',
                                              asset_family: 'creative',
                                              status: 'pending')
    }

    it { is_expected.to be_versioned }

    it "does not create a new version for changes to ignored attributes" do
      tomorrow = 1.day.from_now

      ignored_attrs = { last_contribution_submitted_at: tomorrow,
                         created_at: tomorrow,
                         updated_at: tomorrow
      }
      submission.update_attributes(ignored_attrs)

      expect(submission.versions.count).to eq(1)
    end

  end
end
