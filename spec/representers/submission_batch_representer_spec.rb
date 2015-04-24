require 'spec_helper'

require 'representable/json'

require 'representers/submission_batch_representer'

describe SubmissionBatchRepresenter do

  let(:owner) { OpenStruct.new(:id => 1, :username => 'johndoe') }

  describe "#to_json" do
    let(:data) { {
      id: 1,
      owner_id: 2,
      name: 'My Batch',
      user: OpenStruct.new(:username => 'johndoe'),
      allowed_contribution_type: 'getty_creative_video',
      status: 'open',
      created_at: 2.days.ago,
      updated_at: 5.days.ago
    } }
    let(:submission) { OpenStruct.new(data).extend(described_class) }

    it "creates json from a SubmissionBatch" do
      expected_output = {
        'id' => 1,
        'owner_id' => data[:owner_id],
        'owner_username' => data[:user].username,
        'name' => data[:name],
        'allowed_contribution_type' => data[:allowed_contribution_type],
        'status' => data[:status],
        'created_at' => data[:created_at],
        'updated_at' => data[:updated_at]
      }

      expect(submission).to eq_json(expected_output)
    end
  end

  describe "#from_json when creating a new batch" do
    let(:data) { {
      owner_id: '99',
      name: 'My batch',
      allowed_contribution_type: 'getty_creative_video',
      status: 'wrong status',
      created_at: 5.days.ago,
      updated_at: 3.days.ago
    } }
    let(:submission) do
      submission = OpenStruct.new.extend(described_class)
      submission.from_json(data.to_json, owner_id: owner.id)
      submission
    end

    it "creates a new SubmissionBatch from json" do
      expect(submission.name).to eq(data[:name])
      expect(submission.allowed_contribution_type).to eq(data[:allowed_contribution_type])
    end

    it "cannot set owner_id" do
      expect(submission.owner_id).to eq(owner.id)
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

  describe "#from_json when updating an existing batch" do
    let(:existing_data) { {
      owner_id: 1,
      name: 'My Batch',
      allowed_contribution_type: 'getty_creative_video'
    } }
    let(:new_data) { {
      owner_id: 100,
      name: 'Not My Batch',
      allowed_contribution_type: 'istock_creative_video'
    } }
    let(:submission) { OpenStruct.new(existing_data).extend(described_class) }

    before(:example) do
      submission.from_json(new_data.to_json, owner_id: 99)
    end

    it "cannot override the owner_id" do
      expect(submission.owner_id).to eq(existing_data[:owner_id])
    end

    it "cannot override the allowed_contribution_type" do
      expect(submission.allowed_contribution_type).to eq(existing_data[:allowed_contribution_type])
    end
  end
end
