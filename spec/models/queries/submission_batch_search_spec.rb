require 'active_record_helper'

require 'models/queries/dynamic_search'
require 'models/contribution'
require 'models/user'
require 'models/submission_batch'

require 'models/queries/submission_batch_search'
describe Queries::SubmissionBatchSearch do
  let(:query) { described_class.new(2) }
  let(:records) { @records }

  # Create records once for all examples since they are read only
  before(:context) do
    @records = []
    for x in 0..2
      SubmissionBatch.transaction do
        owner = User.create!(username: "johndoe#{x}",
                             email: "jd#{x}@email.com",
                             account_number: x)
        @records << SubmissionBatch.create!(name: "Submission #{x}",
                                           allowed_contribution_type: 'getty_creative_video',
                                           owner: owner,
                                           status: 'open')
      end
    end
  end

  # Destroy created records
  after(:context) do
    @records.each do |record|
      record.owner.destroy!
      record.destroy!
    end
  end

  describe "#search" do
    it "returns the owner_username field for a basic search" do
      results = query.as_hash.search

      expect(results.length).to be(2)
      expect(results[0]["owner_username"]).to eql('johndoe0')
    end
  end

  describe "#filter_by" do
    it "can filter by owner_username" do
      filter = { field: 'owner_username', operator: '=', value: 'johndoe1' }
      results = query.filter_by(filter).search

      expect(results.length).to be(1)
      expect(results.first.owner.username).to eql('johndoe1')
    end
  end

  describe "#fields_for" do
    it "can select owner_username to be returned" do
      results = query.for_fields('owner_username').search

      expect(results.length).to be(2)
      expect(results.first.owner.username).to eql('johndoe0')
      expect(results.first.respond_to?(:name)).to be(false)
    end
  end

  describe "#sort_by" do
    it "can sort by owner_username" do
      results = query.sort_by('owner_username' => 'desc').search

      expect(results.first.owner.username).to eql(records.last.owner.username)
      expect(results.last.owner.username).to eql(records.second.owner.username)
    end
  end
end
