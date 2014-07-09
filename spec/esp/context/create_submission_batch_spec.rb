require 'active_record_helper'

require 'esp/context/create_submission_batch'
require 'models/submission_batch'

describe Context::CreateSubmissionBatch do
  before(:example) do
    allow(Date).to receive(:current).and_return('now')
  end

  it "sets submission batch name to if not set" do
    submission_batch = described_class.create({})
    expect(submission_batch.name).to eq("Submission date: now")
  end

  it "sets submission batch name to provided name" do
    submission_data = {name: 'My Batch'}
    submission_batch = described_class.create(submission_data)
    expect(submission_batch.name).to eq(submission_data[:name])
  end

  it "sets submission batch status to pending" do
    submission_batch = described_class.create({})
    expect(submission_batch.status).to eq('pending')
  end

  it "saves the submission batch" do
    submission_mock = SubmissionBatch.new(name: 'My Submission')
    expect(submission_mock).to receive(:save)

    allow(SubmissionBatch).to receive(:new).and_return(submission_mock)

    described_class.create({name: 'My Submission'})
  end
end
