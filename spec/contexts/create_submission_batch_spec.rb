require 'active_record_helper'

require 'contexts/create_submission_batch'

require 'models/contribution'
require 'models/submission_batch'

describe CreateSubmissionBatch do
  before(:example) do
    allow(Date).to receive(:current).and_return('now')
  end

  it "sets submission batch name to if not set" do
    submission_batch = described_class.create(SubmissionBatch.new)
    expect(submission_batch.name).to eq("Submission date: now")
  end

  it "sets submission batch name to provided name" do
    name = 'My Batch'

    new_submission = SubmissionBatch.new(name: name)
    submission_batch = described_class.create(new_submission)
    expect(submission_batch.name).to eq(name)
  end

  it "sets submission batch status to open" do
    submission_batch = described_class.create(SubmissionBatch.new)
    expect(submission_batch.status).to eq('open')
  end

  it "saves the submission batch" do
    name = 'My Submission'

    new_submission = SubmissionBatch.new(name: name)
    expect(new_submission).to receive(:save)

    described_class.create(new_submission)
  end
end
