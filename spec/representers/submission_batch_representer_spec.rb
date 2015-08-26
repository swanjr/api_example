require 'active_record_helper'

require 'representable/json'
require 'models/user'
require 'models/contribution'
require 'models/submission_batch'

require 'representers/submission_batch_representer'
describe SubmissionBatchRepresenter do
  let(:owner) { User.new(id: 1, username: 'johndoe') }

  describe "#to_json" do
    let(:data) { {
      id: 1,
      owner_id: owner.id,
      name: 'My Batch',
      owner: owner,
      allowed_contribution_type: 'getty_creative_video',
      status: 'open',
      event_id: '12345678',
      brief_id: 'AB1234',
      assignment_id: '1234',
      created_at: 2.days.ago,
      updated_at: 5.days.ago
    } }

    let(:expected_output) { {
      'id' => 1,
      'owner_id' => data[:owner_id],
      'owner_username' => data[:owner].username,
      'name' => data[:name],
      'allowed_contribution_type' => data[:allowed_contribution_type],
      'status' => data[:status],
      'event_id' => data[:event_id],
      'brief_id' => data[:brief_id],
      'assignment_id' => data[:assignment_id],
      'apply_extracted_metadata' => true,
      'created_at' => data[:created_at],
      'updated_at' => data[:updated_at]
    } }

    it "returns valid json for the SubmissionBatch" do
      submission = SubmissionBatch.new(data).extend(described_class)
      expect(submission).to eq_json(expected_output)
    end

    it "returns valid json for a collection of submission batches" do
      submission1 = SubmissionBatch.new(data)
      submission2 = SubmissionBatch.new(data)

      # Make submissions differ slightly
      submission2.id = 2
      expected_output2 = expected_output.clone
      expected_output2[:id] = 2

      expected_collection = [
        expected_output, expected_output2
      ]

      submissions = [submission1, submission2].extend(described_class.for_collection)
      expect(submissions).to eq_json(expected_collection)
    end
  end

  describe "#from_json" do
    context "when creating a new batch" do
      let(:new_submission) { OpenStruct.new(id: nil, name: nil,
                                            owner_id: nil,
                                            allowed_contribution_type: nil,
                                            created_at: nil, updated_at: nil) }
      let(:data) { {
        owner_id: '99',
        name: 'My batch',
        allowed_contribution_type: 'getty_creative_video',
        status: 'wrong status',
        created_at: 5.days.ago,
        updated_at: 3.days.ago
      } }
      let(:submission) do
        submission = new_submission.extend(described_class)
        submission.from_json(data.to_json, owner_id: owner.id)
        submission
      end

      it "creates a new SubmissionBatch from json" do
        expect(submission.name).to eq(data[:name])
        expect(submission.allowed_contribution_type).to eq(data[:allowed_contribution_type])
      end

      it "cannot set owner_id" do
        expect(submission.owner_id).to be_nil
      end

      it "cannot set status" do
        expect(submission.status).to be_nil
      end

      it "cannot set created_at" do
        expect(submission.created_at).to be_nil
      end

      it "cannot set updated_at" do
        expect(submission.updated_at).to be_nil
      end
    end

    context "when updating an existing batch" do
      let(:existing_data) { {
        owner_id: 1,
        name: 'My Batch',
        allowed_contribution_type: 'getty_creative_video',
        apply_extracted_metadata: true,
        contributions: []
      } }
      let(:new_data) { {
        owner_id: 100,
        name: 'Not My Batch',
        allowed_contribution_type: 'istock_creative_video',
        apply_extracted_metadata: false
      } }
      let(:submission) { OpenStruct.new(existing_data).extend(described_class) }

      before(:example) do
        submission.from_json(new_data.to_json, owner_id: 99)
      end

      it "cannot override owner_id" do
        expect(submission.owner_id).to eq(existing_data[:owner_id])
      end

      it "cannot override allowed_contribution_type" do
        expect(submission.allowed_contribution_type).to eq(existing_data[:allowed_contribution_type])
      end

      it "cannot override apply_extracted_metadata if there are contributions" do
        expect(submission.apply_extracted_metadata).to eq(existing_data[:apply_extracted_metadata])
      end
    end
  end
end
