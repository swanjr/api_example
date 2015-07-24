require 'active_record_helper'

require 'contexts/create_submission_batch'

require 'models/user'
require 'models/contribution'
require 'models/submission_batch'

describe CreateSubmissionBatch do
  let(:uploader) { User.create!(username: 'username', account_number: '100',
                            enabled: false, email: 'user@email.com') }

  before(:example) do
    allow(Date).to receive(:current).and_return('now')
  end

  it "sets submission batch name to if not set" do
    submission_batch = SubmissionBatch.new
    described_class.create!(submission_batch, uploader)

    expect(submission_batch.name).to eq("Submission date: now")
  end

  it "sets submission batch name to provided name" do
    name = 'My Batch'

    submission_batch = SubmissionBatch.new(name: name)
    described_class.create!(submission_batch, uploader.id)

    expect(submission_batch.name).to eq(name)
  end

  it "sets submission batch status to open" do
    submission_batch = SubmissionBatch.new
    described_class.create!(submission_batch, uploader)

    expect(submission_batch.status).to eq('open')
  end

  it "sets submission batch owner_id to the provided id" do
    submission_batch = SubmissionBatch.new
    described_class.create!(submission_batch, uploader)

    expect(submission_batch.owner_id).to eq(uploader.id)
  end

  it "saves the submission batch" do
    name = 'My Submission'

    submission_batch = SubmissionBatch.new(name: name)
    expect(submission_batch).to receive(:save)

    described_class.create!(submission_batch, uploader)
  end
end
