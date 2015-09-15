require 'active_record_helper'

require 'models/user'
require 'models/contribution'
require 'models/validators/blank_validator'

require 'models/submission_batch'

describe SubmissionBatch do

  it { is_expected.to belong_to(:owner) }
  it { is_expected.to have_many(:contributions) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:owner_id) }
    it { is_expected.to validate_presence_of(:name) }

    it { is_expected.to validate_inclusion_of(:allowed_contribution_type).
         in_array(Contribution.types) }
    it { is_expected.to validate_inclusion_of(:status).
         in_array(SubmissionBatch.statuses) }
    it { is_expected.to validate_length_of(:event_id).
         is_at_least(6).is_at_most(10).
         with_message('ID must be 6 to 10 digits') }
    it { is_expected.to validate_numericality_of(:event_id).
         with_message('ID is not a number') }
    it { is_expected.to allow_value('ABSD123','12345666').
         for(:brief_id) }
    it { is_expected.to_not allow_value('ABS D123', ' 12345666', '234sdfsdf ').
         for(:brief_id).with_message('ID must not contain spaces') }
    it { is_expected.to validate_length_of(:brief_id).is_at_most(20) }

    it "should ensure brief_id is blank when event_id is set" do
      submission = SubmissionBatch.new(allowed_contribution_type: 'getty_creative_video',
                                       event_id: '123456', brief_id: 'ABC1234')

      expect(submission.valid?).to be(false)
      expect(submission.errors[:brief_id]).to include(/event ID has already been specified/)
    end

    it "should ensure brief_id is blank for Getty Editorial batches" do
      submission = SubmissionBatch.new(allowed_contribution_type: 'getty_editorial_still',
                                       brief_id: 'ABC1234')

      expect(submission.valid?).to be(false)
      expect(submission.errors[:brief_id]).to include(/ID cannot be assigned to Getty Editorial/)
    end

    it "should ensure brief_id is blank for iStock batches" do
      submission = SubmissionBatch.new(allowed_contribution_type: 'istock_creative_video',
                                       brief_id: 'ABC1234')

      expect(submission.valid?).to be(false)
      expect(submission.errors[:brief_id]).to include(/ID cannot be assigned to iStock/)
    end

    it "should ensure assignment_id is blank for Getty Creative batches" do
      submission = SubmissionBatch.new(allowed_contribution_type: 'getty_creative_video',
                                       assignment_id: 'ABC1234')

      expect(submission.valid?).to be(false)
      expect(submission.errors[:assignment_id]).to include(/ID cannot be assigned to Getty Creative/)
    end

    it "should ensure assignment_id is blank for iStock batches" do
      submission = SubmissionBatch.new(allowed_contribution_type: 'istock_creative_video',
                                       assignment_id: 'ABC1234')

      expect(submission.valid?).to be(false)
      expect(submission.errors[:assignment_id]).to include(/ID cannot be assigned to iStock/)
    end
  end

  describe "#getty_creative?" do
    it "returns true for Getty Creative submission batches" do
      submission = SubmissionBatch.new(allowed_contribution_type: 'getty_creative_video')

      expect(submission.getty_creative?).to be(true)
    end

    it "returns false for submission batches that are not Getty Creative" do
      submission = SubmissionBatch.new(allowed_contribution_type: 'istock_creative_video')

      expect(submission.getty_creative?).to be(false)
    end
  end

  describe "#getty_editorial?" do
    it "returns true for Getty Editorial submission batches" do
      submission = SubmissionBatch.new(allowed_contribution_type: 'getty_editorial_video')

      expect(submission.getty_editorial?).to be(true)
    end

    it "returns false for submission batches that are not Getty Editorial" do
      submission = SubmissionBatch.new(allowed_contribution_type: 'getty_creative_video')

      expect(submission.getty_editorial?).to be(false)
    end
  end

  describe "#istock?" do
    it "returns true for iStock submission batches" do
      submission = SubmissionBatch.new(allowed_contribution_type: 'istock_creative_video')

      expect(submission.istock?).to be(true)
    end

    it "returns false for submission batches that are not iStock" do
      submission = SubmissionBatch.new(allowed_contribution_type: 'getty_creative_video')

      expect(submission.istock?).to be(false)
    end
  end
end
